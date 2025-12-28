import React from 'react';
import { Link } from 'react-router-dom';
import { Calendar, Clock, ArrowRight, Search } from 'lucide-react';
import { BLOG_POSTS } from '../components/blogs/BlogData';
import { SEOKeywordCloud } from '../components/blogs/SEOKeywordCloud';

import { Helmet } from 'react-helmet-async';

const BlogListPage: React.FC = () => {
    const [searchQuery, setSearchQuery] = React.useState('');
    const [selectedCategory, setSelectedCategory] = React.useState('All');

    // Extract unique categories
    const categories = React.useMemo(() => {
        const allCategories = BLOG_POSTS.map(post => post.category);
        return ['All', ...Array.from(new Set(allCategories))];
    }, []);

    // Filter posts
    const filteredPosts = React.useMemo(() => {
        return BLOG_POSTS.filter(post => {
            const matchesSearch =
                post.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                post.subtitle.toLowerCase().includes(searchQuery.toLowerCase()) ||
                post.category.toLowerCase().includes(searchQuery.toLowerCase());

            const matchesCategory = selectedCategory === 'All' || post.category === selectedCategory;

            return matchesSearch && matchesCategory;
        });
    }, [searchQuery, selectedCategory]);

    return (
        <div className="min-h-screen bg-background pt-24">
            <Helmet>
                <title>Blogs | Engineering the Future - Idea Manifest</title>
                <meta name="description" content="Deep dives into AI, Full-Stack Engineering, and Product Strategy from the best application creation teams in Bangalore & Chennai." />
            </Helmet>
            <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
                <header className="mb-12 text-center max-w-3xl mx-auto">
                    <h1 className="text-4xl md:text-7xl font-extrabold text-primary leading-[1.1] mb-8 tracking-tight font-serif">
                        Engineering the <span className="text-transparent bg-clip-text bg-gradient-to-r from-accent via-blue-400 to-cyan-400">Future</span>
                    </h1>
                    <p className="text-secondary text-xl leading-relaxed font-sans mb-12">
                        Deep dives into AI, Full-Stack Engineering, and Product Strategy from the best application creation teams in Bangalore & Chennai.
                    </p>

                    {/* Search and Filter Section */}
                    <div className="flex flex-col md:flex-row gap-4 max-w-2xl mx-auto">
                        <div className="relative flex-grow">
                            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <Search className="h-5 w-5 text-secondary/50" />
                            </div>
                            <input
                                type="text"
                                className="block w-full pl-10 pr-3 py-3 border border-white/10 rounded-xl leading-5 bg-surface text-primary placeholder-secondary/50 focus:outline-none focus:ring-2 focus:ring-accent/50 focus:border-accent/50 sm:text-sm transition-all"
                                placeholder="Search articles..."
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                            />
                        </div>
                        <div className="relative min-w-[200px]">
                            <select
                                value={selectedCategory}
                                onChange={(e) => setSelectedCategory(e.target.value)}
                                className="block w-full pl-3 pr-10 py-3 text-base border border-white/10 rounded-xl focus:outline-none focus:ring-2 focus:ring-accent/50 focus:border-accent/50 sm:text-sm bg-surface text-primary appearance-none cursor-pointer"
                            >
                                {categories.map((category) => (
                                    <option key={category} value={category}>
                                        {category}
                                    </option>
                                ))}
                            </select>
                            <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-secondary/50">
                                <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </div>
                        </div>
                    </div>
                </header>

                {filteredPosts.length > 0 ? (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                        {filteredPosts.map((post) => (
                            <Link
                                key={post.id}
                                to={`/blogs/${post.slug}`}
                                className="group bg-surface border border-white/5 hover:border-accent/50 rounded-2xl overflow-hidden cursor-pointer transition-all duration-300 hover:transform hover:-translate-y-1 hover:shadow-2xl hover:shadow-accent/10 flex flex-col h-full"
                            >
                                {/* Image */}
                                <div className="h-56 overflow-hidden relative">
                                    <div className="absolute inset-0 bg-brand-dark/10 group-hover:bg-transparent transition-colors duration-500 z-10" />
                                    <img
                                        src={post.image}
                                        alt={post.title}
                                        className="w-full h-full object-cover transform group-hover:scale-110 transition-transform duration-700"
                                    />
                                    <div className="absolute top-4 left-4 z-20">
                                        <span className="px-3 py-1 rounded-full bg-background/80 backdrop-blur border border-white/10 text-accent text-xs font-bold uppercase tracking-wider font-sans">
                                            {post.category}
                                        </span>
                                    </div>
                                </div>

                                {/* Content */}
                                <div className="p-6 md:p-8 flex flex-col flex-grow">
                                    <div className="flex items-center gap-3 mb-4 text-xs text-secondary font-medium font-sans">
                                        <span className="flex items-center gap-1"><Calendar size={12} /> {post.date}</span>
                                        <span className="w-1 h-1 bg-white/20 rounded-full"></span>
                                        <span className="flex items-center gap-1"><Clock size={12} /> {post.readTime}</span>
                                    </div>

                                    <h2 className="text-2xl font-bold text-primary mb-3 leading-tight group-hover:text-accent transition-colors font-serif">
                                        {post.title}
                                    </h2>

                                    <p className="text-secondary text-sm leading-relaxed mb-6 line-clamp-3 flex-grow font-sans">
                                        {post.subtitle}
                                    </p>

                                    <div className="flex items-center text-accent font-semibold text-sm group-hover:translate-x-2 transition-transform duration-300 font-sans">
                                        Read Article <ArrowRight size={16} className="ml-2" />
                                    </div>
                                </div>
                            </Link>
                        ))}
                    </div>
                ) : (
                    <div className="text-center py-20">
                        <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-surface border border-white/10 mb-4">
                            <Search className="h-8 w-8 text-secondary/50" />
                        </div>
                        <h3 className="text-xl font-bold text-primary mb-2">No articles found</h3>
                        <p className="text-secondary">Try adjusting your search or filter to find what you're looking for.</p>
                        <button
                            onClick={() => { setSearchQuery(''); setSelectedCategory('All'); }}
                            className="mt-6 text-accent hover:text-accent/80 font-medium transition-colors"
                        >
                            Clear all filters
                        </button>
                    </div>
                )}

                <div className="mt-24 text-center">
                    <button className="bg-surface hover:bg-brand-light text-secondary px-8 py-3 rounded-full font-semibold transition-all border border-white/10 hover:border-accent/50 flex items-center gap-2 mx-auto font-sans">
                        View Archived Posts <ArrowRight size={16} />
                    </button>
                </div>

                {/* Visible SEO Keyword Cloud Hack */}
                <SEOKeywordCloud />
            </div>
        </div>
    );
};

export default BlogListPage;
