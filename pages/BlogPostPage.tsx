import React, { useEffect } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { ArrowLeft, Clock } from 'lucide-react';
import { BLOG_POSTS } from '../components/blogs/BlogData';
import { SchemaMarkup } from '../components/blogs/SchemaMarkup';

const BlogPostPage: React.FC = () => {
    const { slug } = useParams<{ slug: string }>();
    const navigate = useNavigate();

    const post = BLOG_POSTS.find(p => p.slug === slug);

    useEffect(() => {
        window.scrollTo(0, 0);
    }, [slug]);

    if (!post) {
        return (
            <div className="min-h-screen bg-background flex items-center justify-center text-primary">
                <div className="text-center">
                    <h2 className="text-2xl font-bold mb-4">Post not found</h2>
                    <Link to="/blogs" className="text-accent hover:underline">Back to Blogs</Link>
                </div>
            </div>
        );
    }

    return (
        <div className="animate-in fade-in slide-in-from-bottom-4 duration-500 bg-background min-h-screen pt-32">
            <SchemaMarkup post={post} />

            {/* Navigation */}
            <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 pt-8 pb-6">
                <Link
                    to="/blogs"
                    className="flex items-center gap-2 text-secondary hover:text-accent transition-colors group mb-8 font-sans"
                >
                    <div className="p-2 rounded-full bg-surface border border-white/10 group-hover:border-accent transition-colors">
                        <ArrowLeft size={20} />
                    </div>
                    <span className="font-medium">Back to Articles</span>
                </Link>
            </div>

            {/* Hero Section */}
            <div className="relative w-full h-[50vh] min-h-[400px]">
                <div className="absolute inset-0 bg-surface">
                    <img
                        src={post.image}
                        alt={post.title}
                        className="w-full h-full object-cover opacity-60"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-background via-background/60 to-transparent" />
                </div>

                <div className="absolute bottom-0 left-0 right-0 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 pb-12">
                    <div className="flex flex-wrap gap-4 mb-6">
                        <span className="bg-accent text-white px-4 py-1.5 rounded-full text-sm font-bold tracking-wide uppercase font-sans">
                            {post.category}
                        </span>
                        <span className="flex items-center gap-2 text-primary bg-surface/50 backdrop-blur px-4 py-1.5 rounded-full border border-white/10 font-sans">
                            <Clock size={14} /> {post.readTime}
                        </span>
                    </div>
                    <h1 className="text-3xl md:text-5xl lg:text-6xl font-extrabold text-primary leading-tight mb-6 shadow-black drop-shadow-lg font-serif">
                        {post.title}
                    </h1>
                    <p className="text-xl text-secondary max-w-2xl leading-relaxed font-sans">
                        {post.subtitle}
                    </p>
                </div>
            </div>

            {/* Content */}
            <article className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
                <div className="prose prose-invert prose-lg max-w-none prose-headings:text-primary prose-headings:font-serif prose-p:text-secondary prose-p:font-sans prose-strong:text-primary prose-a:text-accent hover:prose-a:text-blue-400">
                    {post.fullContent}
                </div>

                {/* Author Bio */}
                <div className="mt-20 pt-10 border-t border-white/10 flex items-center gap-6">
                    <div className="w-16 h-16 rounded-full bg-brand-dark/50 flex items-center justify-center text-accent font-bold text-xl border border-accent/30">
                        {post.author.charAt(0)}
                    </div>
                    <div>
                        <p className="text-secondary/60 text-sm uppercase tracking-wider font-bold mb-1 font-sans">Written By</p>
                        <h4 className="text-primary font-bold text-lg font-serif">{post.author}</h4>
                        <p className="text-secondary text-sm font-sans">Idea Manifest Team</p>
                    </div>
                </div>
            </article>
        </div>
    );
};

export default BlogPostPage;
