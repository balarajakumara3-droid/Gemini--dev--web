import React, { useEffect, useState } from 'react';
import { motion, useMotionValue, useSpring } from 'framer-motion';
import { useLocation } from 'react-router-dom';

export const CustomCursor: React.FC = () => {
  const { pathname } = useLocation();
  const isRealEstateDemo = pathname.startsWith('/demos/real-estate');

  if (isRealEstateDemo) return null;

  const cursorX = useMotionValue(-100);
  const cursorY = useMotionValue(-100);

  const springConfig = { damping: 25, stiffness: 700 };
  const cursorXSpring = useSpring(cursorX, springConfig);
  const cursorYSpring = useSpring(cursorY, springConfig);

  const [hovered, setHovered] = useState(false);

  useEffect(() => {
    const moveCursor = (e: MouseEvent) => {
      cursorX.set(e.clientX - 16);
      cursorY.set(e.clientY - 16);
    };

    const handleMouseOver = (e: MouseEvent) => {
      const target = e.target as HTMLElement;
      if (target.tagName === 'A' || target.tagName === 'BUTTON' || target.closest('a') || target.closest('button')) {
        setHovered(true);
      } else {
        setHovered(false);
      }
    };

    window.addEventListener('mousemove', moveCursor);
    window.addEventListener('mouseover', handleMouseOver);

    return () => {
      window.removeEventListener('mousemove', moveCursor);
      window.removeEventListener('mouseover', handleMouseOver);
    };
  }, [cursorX, cursorY]);

  return (
    <motion.div
      className="custom-cursor fixed top-0 left-0 w-8 h-8 border border-accent rounded-full pointer-events-none z-[9999]"
      style={{
        translateX: cursorXSpring,
        translateY: cursorYSpring,
      }}
      animate={{
        scale: hovered ? 1.5 : 1,
        borderColor: hovered ? 'rgba(129, 140, 248, 0)' : 'rgba(255, 255, 255, 0.4)', // Faded white/indigo
        backgroundColor: hovered ? 'rgba(129, 140, 248, 0.1)' : 'rgba(255, 255, 255, 0)',
      }}
      transition={{ duration: 0.2 }}
    >
      <motion.div
        className="w-1.5 h-1.5 bg-white rounded-full absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
        animate={{
          scale: hovered ? 0.5 : 1,
          backgroundColor: hovered ? '#818cf8' : '#ffffff' // Accent on hover, White default
        }}
      />
    </motion.div>
  );
};