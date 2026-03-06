import { useEffect, useRef, useState } from 'react';

const LOCK_COOLDOWN_MS = 450;
const EXIT_TRANSITION_MS = 250;
const WHEEL_THRESHOLD = 90;
const TOUCH_THRESHOLD = 48;
const NAVIGATION_COOLDOWN_MS = 220;

const clampIndex = (index: number, itemCount: number) => {
  if (itemCount <= 0) {
    return 0;
  }

  return Math.max(0, Math.min(index, itemCount - 1));
};

export const useLockedHorizontalCarousel = (itemCount: number) => {
  const sectionRef = useRef<HTMLElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const [isLocked, setIsLocked] = useState(false);
  const [currentIndexState, setCurrentIndexState] = useState(0);
  const [translateX, setTranslateX] = useState(0);

  const isLockedRef = useRef(false);
  const currentIndexRef = useRef(0);
  const isTransitioningRef = useRef(false);
  const hasExitedZoneRef = useRef(false);
  const lastLockChangeRef = useRef(0);
  const scrollAccumulatorRef = useRef(0);
  const lastGestureAtRef = useRef(0);
  const pageScrollStylesRef = useRef<{
    bodyOverflow: string;
    htmlOverflow: string;
    bodyPaddingRight: string;
  } | null>(null);
  const touchStartRef = useRef({ x: 0, y: 0 });
  const touchCurrentRef = useRef({ x: 0, y: 0 });

  const setCurrentIndex = (value: number | ((prev: number) => number)) => {
    setCurrentIndexState((prev) => {
      const nextValue = typeof value === 'function' ? value(prev) : value;
      const clampedValue = clampIndex(nextValue, itemCount);
      currentIndexRef.current = clampedValue;
      return clampedValue;
    });
  };

  const unlockPageScroll = () => {
    const storedStyles = pageScrollStylesRef.current;
    if (!storedStyles) {
      return;
    }

    document.body.style.overflow = storedStyles.bodyOverflow;
    document.documentElement.style.overflow = storedStyles.htmlOverflow;
    document.body.style.paddingRight = storedStyles.bodyPaddingRight;
    pageScrollStylesRef.current = null;
  };

  const lockPageScroll = () => {
    if (pageScrollStylesRef.current) {
      return;
    }

    pageScrollStylesRef.current = {
      bodyOverflow: document.body.style.overflow,
      htmlOverflow: document.documentElement.style.overflow,
      bodyPaddingRight: document.body.style.paddingRight,
    };

    const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth;

    document.body.style.overflow = 'hidden';
    document.documentElement.style.overflow = 'hidden';

    if (scrollbarWidth > 0) {
      document.body.style.paddingRight = `${scrollbarWidth}px`;
    }
  };

  const exitCarousel = () => {
    const now = Date.now();
    if (now - lastLockChangeRef.current < LOCK_COOLDOWN_MS) {
      return;
    }

    isTransitioningRef.current = true;
    lastLockChangeRef.current = now;
    lastGestureAtRef.current = now;
    hasExitedZoneRef.current = true;
    scrollAccumulatorRef.current = 0;
    isLockedRef.current = false;
    setIsLocked(false);
    unlockPageScroll();

    window.setTimeout(() => {
      isTransitioningRef.current = false;
    }, EXIT_TRANSITION_MS);
  };

  const moveBy = (direction: 1 | -1) => {
    const activeIndex = currentIndexRef.current;

    if (direction === 1) {
      if (activeIndex < itemCount - 1) {
        setCurrentIndex(activeIndex + 1);
        return;
      }

      exitCarousel();
      return;
    }

    if (activeIndex > 0) {
      setCurrentIndex(activeIndex - 1);
      return;
    }

    exitCarousel();
  };

  const handleDirectionalIntent = (delta: number) => {
    const now = Date.now();
    if (now - lastGestureAtRef.current < NAVIGATION_COOLDOWN_MS) {
      return;
    }

    const accumulator = scrollAccumulatorRef.current;

    if ((accumulator > 0 && delta < 0) || (accumulator < 0 && delta > 0)) {
      scrollAccumulatorRef.current = delta;
    } else {
      scrollAccumulatorRef.current += delta;
    }

    if (scrollAccumulatorRef.current >= WHEEL_THRESHOLD) {
      lastGestureAtRef.current = now;
      scrollAccumulatorRef.current = 0;
      moveBy(1);
    } else if (scrollAccumulatorRef.current <= -WHEEL_THRESHOLD) {
      lastGestureAtRef.current = now;
      scrollAccumulatorRef.current = 0;
      moveBy(-1);
    }
  };

  useEffect(() => {
    isLockedRef.current = isLocked;
  }, [isLocked]);

  useEffect(() => {
    currentIndexRef.current = clampIndex(currentIndexState, itemCount);
  }, [currentIndexState, itemCount]);

  useEffect(() => {
    if (!containerRef.current) {
      return;
    }

    const updateTransform = () => {
      const trackWidth = containerRef.current?.parentElement?.clientWidth ?? window.innerWidth;
      const cardWidth = trackWidth < 768
        ? Math.min(trackWidth * 0.82, 320)
        : Math.min(trackWidth * 0.35, 400);
      const gap = trackWidth < 768 ? 20 : 32;
      const centerOffset = (trackWidth - cardWidth) / 2;

      setTranslateX(centerOffset - (currentIndexRef.current * (cardWidth + gap)));
    };

    updateTransform();
    window.addEventListener('resize', updateTransform);

    return () => {
      window.removeEventListener('resize', updateTransform);
    };
  }, [currentIndexState]);

  useEffect(() => {
    const section = sectionRef.current;
    if (!section) {
      return;
    }

    const checkPosition = () => {
      if (isTransitioningRef.current || isLockedRef.current) {
        return;
      }

      const rect = section.getBoundingClientRect();
      const viewportHeight = window.innerHeight;
      const visibleHeight = Math.min(rect.bottom, viewportHeight) - Math.max(rect.top, 0);
      const isVisibleEnough = visibleHeight > Math.min(rect.height * 0.45, viewportHeight * 0.6);
      const isInActiveZone = rect.top <= viewportHeight * 0.46 && rect.bottom >= viewportHeight * 0.54;

      if (!isInActiveZone) {
        hasExitedZoneRef.current = false;
      }

      const now = Date.now();
      const cooldownPassed = now - lastLockChangeRef.current > LOCK_COOLDOWN_MS;

      if (isVisibleEnough && isInActiveZone && cooldownPassed && !hasExitedZoneRef.current) {
        lastLockChangeRef.current = now;
        scrollAccumulatorRef.current = 0;
        lastGestureAtRef.current = now;
        isLockedRef.current = true;
        setIsLocked(true);
        lockPageScroll();
        section.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    };

    window.addEventListener('scroll', checkPosition, { passive: true });
    window.addEventListener('resize', checkPosition);
    checkPosition();

    return () => {
      window.removeEventListener('scroll', checkPosition);
      window.removeEventListener('resize', checkPosition);
      unlockPageScroll();
    };
  }, []);

  useEffect(() => {
    const section = sectionRef.current;
    if (!section) {
      return;
    }

    const handleWheel = (event: WheelEvent) => {
      if (!isLockedRef.current) {
        return;
      }

      const dominantDelta = Math.abs(event.deltaY) >= Math.abs(event.deltaX)
        ? event.deltaY
        : event.deltaX;

      if (Math.abs(dominantDelta) < 2) {
        return;
      }

      event.preventDefault();
      event.stopPropagation();
      handleDirectionalIntent(dominantDelta);
    };

    const handleTouchStart = (event: TouchEvent) => {
      if (!isLockedRef.current) {
        return;
      }

      const touch = event.touches[0];
      touchStartRef.current = { x: touch.clientX, y: touch.clientY };
      touchCurrentRef.current = { x: touch.clientX, y: touch.clientY };
      scrollAccumulatorRef.current = 0;
    };

    const handleTouchMove = (event: TouchEvent) => {
      if (!isLockedRef.current) {
        return;
      }

      const touch = event.touches[0];
      touchCurrentRef.current = { x: touch.clientX, y: touch.clientY };

      const deltaX = Math.abs(touchCurrentRef.current.x - touchStartRef.current.x);
      const deltaY = Math.abs(touchCurrentRef.current.y - touchStartRef.current.y);

      if (deltaY >= deltaX) {
        event.preventDefault();
      }
    };

    const handleTouchEnd = () => {
      if (!isLockedRef.current) {
        return;
      }

      const deltaX = Math.abs(touchCurrentRef.current.x - touchStartRef.current.x);
      const deltaY = touchStartRef.current.y - touchCurrentRef.current.y;

      if (Math.abs(deltaY) > deltaX && Math.abs(deltaY) > TOUCH_THRESHOLD) {
        moveBy(deltaY > 0 ? 1 : -1);
      }

      touchStartRef.current = { x: 0, y: 0 };
      touchCurrentRef.current = { x: 0, y: 0 };
    };

    const handleKeyDown = (event: KeyboardEvent) => {
      if (!isLockedRef.current) {
        return;
      }

      if (event.key === 'ArrowDown' || event.key === 'PageDown' || event.key === ' ') {
        event.preventDefault();
        moveBy(1);
      } else if (event.key === 'ArrowUp' || event.key === 'PageUp') {
        event.preventDefault();
        moveBy(-1);
      } else if (event.key === 'Escape') {
        event.preventDefault();
        exitCarousel();
      }
    };

    window.addEventListener('wheel', handleWheel, { passive: false, capture: true });
    window.addEventListener('keydown', handleKeyDown, { capture: true });
    section.addEventListener('touchstart', handleTouchStart, { passive: true });
    section.addEventListener('touchmove', handleTouchMove, { passive: false });
    section.addEventListener('touchend', handleTouchEnd, { passive: true });

    return () => {
      window.removeEventListener('wheel', handleWheel, { capture: true });
      window.removeEventListener('keydown', handleKeyDown, { capture: true });
      section.removeEventListener('touchstart', handleTouchStart);
      section.removeEventListener('touchmove', handleTouchMove);
      section.removeEventListener('touchend', handleTouchEnd);
    };
  }, []);

  const goToPrevious = () => {
    scrollAccumulatorRef.current = 0;
    moveBy(-1);
  };

  const goToNext = () => {
    scrollAccumulatorRef.current = 0;
    moveBy(1);
  };

  return {
    sectionRef,
    containerRef,
    currentIndex: currentIndexState,
    isLocked,
    translateX,
    setCurrentIndex,
    goToPrevious,
    goToNext,
  };
};
