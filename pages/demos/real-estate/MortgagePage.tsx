import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Calculator, DollarSign, Percent, Calendar, TrendingUp, Info } from 'lucide-react';

export const RealEstateMortgage: React.FC = () => {
    // Calculator State
    const [homePrice, setHomePrice] = useState(500000);
    const [downPayment, setDownPayment] = useState(100000);
    const [interestRate, setInterestRate] = useState(6.5);
    const [loanTerm, setLoanTerm] = useState(30);

    const [monthlyPayment, setMonthlyPayment] = useState(0);

    // Calculate Payment
    useEffect(() => {
        const principal = homePrice - downPayment;
        const monthlyRate = interestRate / 100 / 12;
        const numberOfPayments = loanTerm * 12;

        if (principal > 0 && interestRate > 0) {
            const payment = (principal * monthlyRate * Math.pow(1 + monthlyRate, numberOfPayments)) / (Math.pow(1 + monthlyRate, numberOfPayments) - 1);
            setMonthlyPayment(payment);
        } else {
            setMonthlyPayment(0);
        }
    }, [homePrice, downPayment, interestRate, loanTerm]);

    const formatCurrency = (val: number) => {
        return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(val);
    };

    return (
        <div className="bg-white min-h-screen pb-20">
            {/* Hero */}
            <section className="bg-slate-900 text-white py-16 px-6">
                <div className="container mx-auto text-center max-w-3xl">
                    <h1 className="text-3xl md:text-5xl font-bold mb-4">Mortgage Calculator</h1>
                    <p className="text-slate-400 text-lg">
                        Estimate your monthly mortgage payments and see how different interest rates and loan terms affect your budget.
                    </p>
                </div>
            </section>

            <div className="container mx-auto px-6 -mt-8">
                <div className="bg-white rounded-xl shadow-xl border border-slate-200 overflow-hidden">
                    <div className="grid grid-cols-1 lg:grid-cols-2">
                        {/* Inputs */}
                        <div className="p-8 md:p-12 space-y-8 bg-white">
                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-2 flex items-center gap-2">
                                    <DollarSign size={16} /> Home Price
                                </label>
                                <div className="relative">
                                    <span className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">$</span>
                                    <input
                                        type="number"
                                        value={homePrice}
                                        onChange={(e) => setHomePrice(Number(e.target.value))}
                                        className="w-full pl-8 pr-4 py-3 rounded-lg border border-slate-300 focus:border-[#d93025] focus:ring-1 focus:ring-[#d93025] outline-none font-bold text-lg text-slate-900"
                                    />
                                </div>
                                <input
                                    type="range"
                                    min="100000"
                                    max="2000000"
                                    step="5000"
                                    value={homePrice}
                                    onChange={(e) => setHomePrice(Number(e.target.value))}
                                    className="w-full mt-3 accent-[#d93025]"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-2 flex items-center gap-2">
                                    <DollarSign size={16} /> Down Payment
                                </label>
                                <div className="grid grid-cols-2 gap-4">
                                    <div className="relative">
                                        <span className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">$</span>
                                        <input
                                            type="number"
                                            value={downPayment}
                                            onChange={(e) => setDownPayment(Number(e.target.value))}
                                            className="w-full pl-8 pr-4 py-3 rounded-lg border border-slate-300 focus:border-[#d93025] outline-none font-bold text-slate-900"
                                        />
                                    </div>
                                    <div className="relative">
                                        <span className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400">%</span>
                                        <input
                                            type="number"
                                            value={Math.round((downPayment / homePrice) * 100)}
                                            readOnly
                                            className="w-full pl-4 pr-8 py-3 rounded-lg border border-slate-200 bg-slate-50 text-slate-500 font-medium"
                                        />
                                    </div>
                                </div>
                            </div>

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                                <div>
                                    <label className="block text-sm font-bold text-slate-700 mb-2 flex items-center gap-2">
                                        <Percent size={16} /> Interest Rate
                                    </label>
                                    <div className="relative">
                                        <input
                                            type="number"
                                            step="0.1"
                                            value={interestRate}
                                            onChange={(e) => setInterestRate(Number(e.target.value))}
                                            className="w-full px-4 py-3 rounded-lg border border-slate-300 focus:border-[#d93025] outline-none font-bold text-slate-900"
                                        />
                                    </div>
                                </div>
                                <div>
                                    <label className="block text-sm font-bold text-slate-700 mb-2 flex items-center gap-2">
                                        <Calendar size={16} /> Loan Term
                                    </label>
                                    <select
                                        value={loanTerm}
                                        onChange={(e) => setLoanTerm(Number(e.target.value))}
                                        className="w-full px-4 py-3 rounded-lg border border-slate-300 focus:border-[#d93025] outline-none font-bold text-slate-900"
                                    >
                                        <option value={30}>30 Years Fixed</option>
                                        <option value={20}>20 Years Fixed</option>
                                        <option value={15}>15 Years Fixed</option>
                                        <option value={10}>10 Years Fixed</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        {/* Result */}
                        <div className="bg-slate-50 p-8 md:p-12 flex flex-col justify-center border-t lg:border-t-0 lg:border-l border-slate-200">
                            <div className="text-center">
                                <span className="text-slate-500 font-medium uppercase tracking-wide text-sm">Estimated Monthly Payment</span>
                                <h2 className="text-5xl md:text-6xl font-extrabold text-[#d93025] mt-2 mb-6">
                                    {formatCurrency(monthlyPayment)}
                                </h2>
                                <p className="text-slate-400 text-sm mb-8">
                                    Principal & Interest only. Does not include taxes or insurance.
                                </p>

                                <button className="w-full py-4 bg-[#d93025] text-white rounded-lg font-bold hover:bg-[#b02018] transition-colors shadow-lg shadow-red-500/20">
                                    Get Pre-Approved
                                </button>
                            </div>

                            <div className="mt-12 bg-white p-6 rounded-lg border border-slate-200 shadow-sm">
                                <h3 className="font-bold text-slate-900 mb-4 flex items-center gap-2">
                                    <TrendingUp className="text-green-600" size={20} /> Current Rates
                                </h3>
                                <div className="space-y-3">
                                    <div className="flex justify-between items-center text-sm border-b border-slate-100 pb-2">
                                        <span className="text-slate-600">30-Year Fixed</span>
                                        <span className="font-bold text-slate-900">6.92%</span>
                                    </div>
                                    <div className="flex justify-between items-center text-sm border-b border-slate-100 pb-2">
                                        <span className="text-slate-600">15-Year Fixed</span>
                                        <span className="font-bold text-slate-900">6.28%</span>
                                    </div>
                                    <div className="flex justify-between items-center text-sm">
                                        <span className="text-slate-600">5/1 ARM</span>
                                        <span className="font-bold text-slate-900">6.55%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Educational Content */}
            <section className="container mx-auto px-6 py-20">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
                    <div>
                        <h3 className="text-2xl font-bold text-slate-900 mb-4">First-Time Home Buyer Advice</h3>
                        <p className="text-slate-600 leading-relaxed mb-6">
                            Buying your first home is a big step. Start by checking your credit score and saving for a down payment.
                            Understanding your budget is key to finding a home you can afford comfortably.
                        </p>
                        <a href="#" className="text-[#d93025] font-bold hover:underline">Read our complete guide &rarr;</a>
                    </div>
                    <div>
                        <h3 className="text-2xl font-bold text-slate-900 mb-4">Refinancing Your Mortgage</h3>
                        <p className="text-slate-600 leading-relaxed mb-6">
                            Refinancing can lower your monthly payments, reduce your interest rate, or help you pay off your loan faster.
                            Calculate your break-even point to see if it makes sense for you.
                        </p>
                        <a href="#" className="text-[#d93025] font-bold hover:underline">See refinancing rates &rarr;</a>
                    </div>
                </div>
            </section>
        </div>
    );
};
