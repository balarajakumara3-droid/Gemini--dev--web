import React from 'react';
import {
    SiFlutter,
    SiKotlin,
    SiNextdotjs,
    SiNodedotjs,
    SiPython,
    SiReact,
    SiSupabase,
    SiSwift,
} from 'react-icons/si';

export const ReactIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(SiReact, props)
);

export const NextJsIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(SiNextdotjs, props)
);

export const NodeJsIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(SiNodedotjs, props)
);

export const FlutterIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(SiFlutter, props)
);

export const SwiftIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(SiSwift, props)
);

export const KotlinIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(SiKotlin, props)
);

export const FastApiIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(
        "svg",
        { viewBox: "0 0 24 24", fill: "none", ...props },
        React.createElement("path", {
            d: "M12 0C5.375 0 0 5.375 0 12c0 6.627 5.375 12 12 12 6.626 0 12-5.373 12-12 0-6.625-5.373-12-12-12zm-.624 21.62v-7.528H7.19L13.203 2.38v7.528h4.029L11.376 21.62z",
            fill: "currentColor"
        })
    )
);

export const SupabaseIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(SiSupabase, props)
);

export const PythonIcon = (props: React.SVGProps<SVGSVGElement>) => (
    React.createElement(SiPython, props)
);
