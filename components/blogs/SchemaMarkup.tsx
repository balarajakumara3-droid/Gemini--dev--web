import React, { useEffect } from 'react';
import { BlogPostData, SEO_KEYWORDS } from './BlogData';

export const SchemaMarkup: React.FC<{ post: BlogPostData }> = ({ post }) => {
    useEffect(() => {
        const script = document.createElement('script');
        script.type = "application/ld+json";
        const schema = {
            "@context": "https://schema.org",
            "@type": "BlogPosting",
            "headline": post.title,
            "alternativeHeadline": post.subtitle,
            "image": post.image,
            "author": {
                "@type": "Organization",
                "name": "Idea Manifest",
                "url": "https://www.ideamanifest.com"
            },
            "publisher": {
                "@type": "Organization",
                "name": "Idea Manifest",
                "logo": {
                    "@type": "ImageObject",
                    "url": "https://www.ideamanifest.com/logo.png"
                }
            },
            "genre": post.category,
            "keywords": SEO_KEYWORDS.join(", "),
            "wordcount": "1000", // Estimation
            "url": window.location.href,
            "datePublished": post.date,
            "dateCreated": post.date,
            "dateModified": new Date().toISOString(),
            "description": post.subtitle,
            "articleBody": "Full content available on page."
        };
        script.text = JSON.stringify(schema);
        document.head.appendChild(script);

        return () => {
            document.head.removeChild(script);
        }
    }, [post]);

    return null;
};
