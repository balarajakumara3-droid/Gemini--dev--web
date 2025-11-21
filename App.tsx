import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  ArrowRight, 
  Bot, 
  FileText, 
  Monitor, 
  Smartphone, 
  Cpu, 
  ScanEye, 
  Lightbulb, 
  Building2, 
  Target, 
  Cloud, 
  Database, 
  Sparkles, 
  MessageSquareCode, 
  Image as ImageIcon,
  ChevronDown,
  Twitter,
  Facebook,
  Instagram,
  Linkedin,
  ArrowUp,
  Brain,
  Settings,
  Code,
  Layers,
  Server,
  Zap
} from 'lucide-react';
import { CustomCursor } from './components/CustomCursor';
import { Navbar } from './components/Navbar';
import { ParticleBackground } from './components/ParticleBackground';

// Helper Components
const RevealText = ({ children, delay = 0, className = "" }: { children?: React.ReactNode, delay?: number, className?: string }) => {
    return (
        <div className={`overflow-hidden ${className}`}>
            <motion.div
                initial={{ y: "100%" }}
                whileInView={{ y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.8, delay, ease: [0.19, 1, 0.22, 1] }}
            >
                {children}
            </motion.div>
        </div>
    )
}

const ServiceItemLeft = ({ title, description, Icon }: { title: string, description: string, Icon: any }) => (
    <motion.div 
        initial={{ opacity: 0, x: -20 }}
        whileInView={{ opacity: 1, x: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.5 }}
        className="flex flex-col md:flex-row items-center md:text-right gap-6 mb-16 md:mb-24"
    >
        <div className="flex-1 order-2 md:order-1">
            <h3 className="font-display text-2xl font-medium mb-2">{title}</h3>
            <p className="text-secondary text-sm leading-relaxed mb-4">{description}</p>
            <a href="#" className="inline-flex items-center gap-2 text-brand-red text-sm font-semibold uppercase tracking-widest group justify-end">
                Learn More <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
            </a>
        </div>
        <div className="shrink-0 order-1 md:order-2 p-4 border border-white/10 rounded-full bg-surface/50">
             <Icon size={32} strokeWidth={1} />
        </div>
    </motion.div>
);

const ServiceItemRight = ({ title, description, Icon }: { title: string, description: string, Icon: any }) => (
    <motion.div 
        initial={{ opacity: 0, x: 20 }}
        whileInView={{ opacity: 1, x: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.5 }}
        className="flex flex-col md:flex-row items-center md:text-left gap-6 mb-16 md:mb-24"
    >
         <div className="shrink-0 p-4 border border-white/10 rounded-full bg-surface/50">
             <Icon size={32} strokeWidth={1} />
        </div>
        <div className="flex-1">
            <h3 className="font-display text-2xl font-medium mb-2">{title}</h3>
            <p className="text-secondary text-sm leading-relaxed mb-4">{description}</p>
            <a href="#" className="inline-flex items-center gap-2 text-brand-red text-sm font-semibold uppercase tracking-widest group">
                Learn More <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
            </a>
        </div>
    </motion.div>
);

const CollaborateCard = ({ title, description, Icon }: { title: string, description: string, Icon: any }) => (
    <div className="border border-white/10 p-8 md:p-12 hover:border-brand-red/50 transition-colors duration-300 bg-surface/30 backdrop-blur-sm flex flex-col items-center text-center group h-full rounded-xl">
        <div className="mb-6 text-white group-hover:scale-110 transition-transform duration-500">
            <Icon size={64} strokeWidth={1} />
        </div>
        <h3 className="font-display text-2xl font-bold mb-4">{title}</h3>
        <p className="text-secondary text-sm leading-relaxed mb-8">{description}</p>
        <a href="#" className="mt-auto flex items-center gap-2 text-brand-red text-sm font-semibold uppercase tracking-widest group-hover:gap-3 transition-all">
            Learn More <ArrowRight size={16} />
        </a>
    </div>
);

const TechItem = ({ title, description, Icon }: { title: string, description: string, Icon: any }) => (
    <div className="flex gap-6 mb-12 items-start">
        <div className="shrink-0 mt-1 text-brand-red/80">
             <Icon size={32} strokeWidth={1.5} />
        </div>
        <div>
            <h3 className="font-display text-xl font-medium mb-2">{title}</h3>
            <p className="text-secondary text-sm leading-relaxed mb-3 max-w-md">{description}</p>
            <a href="#" className="flex items-center gap-2 text-brand-red text-xs font-semibold uppercase tracking-widest group">
                Learn More <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
            </a>
        </div>
    </div>
);

const AccordionItem = ({ question, answer, isOpen, onClick }: { question: string, answer: string, isOpen: boolean, onClick: () => void }) => (
    <div className="border border-white/10 rounded-lg mb-4 overflow-hidden bg-surface/30">
        <button 
            className="w-full py-6 px-6 flex justify-between items-center text-left hover:bg-white/5 transition-colors"
            onClick={onClick}
        >
            <div className="flex items-center gap-4">
                <div className={`w-6 h-6 rounded-full flex items-center justify-center bg-brand-red/20 text-brand-red transition-transform duration-300`}>
                    <ArrowRight size={14} className={`${isOpen ? 'rotate-90' : ''}`} />
                </div>
                <span className="font-medium text-lg md:text-xl">{question}</span>
            </div>
        </button>
        <AnimatePresence>
            {isOpen && (
                <motion.div
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: 'auto', opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.3 }}
                >
                    <div className="pb-6 px-6 pl-16 text-secondary leading-relaxed text-sm md:text-base">
                        {answer}
                    </div>
                </motion.div>
            )}
        </AnimatePresence>
    </div>
);

const App: React.FC = () => {
  const [openFaq, setOpenFaq] = useState<number | null>(0);

  return (
    <div className="bg-background text-primary min-h-screen selection:bg-brand-red selection:text-white overflow-x-hidden">
      <CustomCursor />
      <Navbar />

      {/* HERO SECTION */}
      <section id="home" className="min-h-screen flex flex-col justify-center items-center relative px-6 md:px-12 pt-20">
        <ParticleBackground />
        <div className="z-10 max-w-6xl mx-auto w-full mt-12">
            <RevealText className="mb-2">
                <h1 className="font-display font-bold text-[10vw] md:text-8xl leading-none tracking-tight text-white">
                    Let's <span className="text-brand-red">Transform</span>
                </h1>
            </RevealText>
            <RevealText delay={0.1}>
                 <h1 className="font-display font-bold text-[8vw] md:text-8xl leading-none tracking-tight text-white">
                    With Generative AI
                </h1>
            </RevealText>

            <motion.div 
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.8, duration: 1 }}
                className="mt-24 md:mt-32 grid grid-cols-1 md:grid-cols-12 gap-8"
            >
                <div className="md:col-span-12 text-center mb-8">
                     <h2 className="text-brand-red text-xl md:text-3xl font-medium mb-6">
                        Transforming Businesses with Tailored AI Solutions:<br />Diseño Pinnacle's Generative AI Expertise
                     </h2>
                     <p className="text-secondary text-sm md:text-lg max-w-4xl mx-auto leading-relaxed">
                        Diseño Pinnacle is a leading Generative AI consulting company, dedicated to crafting and implementing bespoke AI solutions that empower our clients to optimize business processes and drive revenue growth. With expertise spanning various AI domains, from chatbot and conversational AI to recommendation systems, natural language processing (NLP), computer vision, and voice and speech recognition, we tailor solutions to meet diverse needs.
                     </p>
                </div>
            </motion.div>
        </div>
        
        {/* Floating abstract particles handled by ParticleBackground */}
      </section>

      {/* SERVICES SECTION */}
      <section id="services" className="py-32 px-6 md:px-12 relative z-10 bg-[#050505]">
          <div className="max-w-7xl mx-auto">
              <div className="flex flex-col md:flex-row gap-12 items-center">
                  {/* Left Column */}
                  <div className="flex-1 w-full">
                      <ServiceItemLeft
                          title="AI Chatbots" 
                          description="In today's fast-paced digital landscape, customer expectations are higher than ever."
                          Icon={Settings}
                      />
                      <ServiceItemLeft
                          title="Web Development" 
                          description="Web applications tailored to meet the unique needs of your business and industry."
                          Icon={Monitor}
                      />
                      <ServiceItemLeft
                          title="Custom GPT" 
                          description="Custom GPT represents a game-changing solution for businesses."
                          Icon={Code}
                      />
                  </div>

                  {/* Center Visual */}
                  <div className="shrink-0 relative hidden md:flex justify-center items-center w-64 h-64">
                      <motion.div 
                        initial={{ scale: 0.8, opacity: 0 }}
                        whileInView={{ scale: 1, opacity: 1 }}
                        viewport={{ once: true }}
                        transition={{ duration: 0.8 }}
                        className="w-48 h-48 rounded-full bg-brand-red flex items-center justify-center shadow-[0_0_50px_rgba(163,163,163,0.3)] z-10"
                      >
                          <Brain size={80} className="text-white" strokeWidth={1.5} />
                      </motion.div>
                      {/* Connecting lines would be complex SVG, skipping for cleaner code but layout matches */}
                  </div>

                  {/* Right Column */}
                  <div className="flex-1 w-full">
                      <ServiceItemRight
                          title="Predictive Analytics" 
                          description="We fuse advanced AI technologies with deep domain expertise to craft bespoke predictive analytics solutions."
                          Icon={FileText}
                      />
                      <ServiceItemRight
                          title="Mobile Application" 
                          description="Mobile applications tailored to meet the distinctive needs of your business and industry."
                          Icon={Lightbulb}
                      />
                      <ServiceItemRight
                          title="Image Recognition" 
                          description="We blend AI technologies to deliver image recognition solutions to your business requirements."
                          Icon={Target}
                      />
                  </div>
              </div>
          </div>
      </section>

      {/* REVOLUTIONIZING SECTION (From PDF Page 2 Top) */}
      <section className="py-20 px-6 md:px-12 bg-surface/20">
          <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-16">
               <div className="text-center md:text-left">
                    <div className="flex flex-col items-center md:items-start gap-4">
                        <div className="p-4 border border-white/10 rounded-xl inline-block mb-4">
                            <ScanEye size={48} strokeWidth={1} />
                        </div>
                        <h3 className="text-2xl font-display font-bold mb-2">Revolutionizing AI Development</h3>
                        <p className="text-secondary text-sm mb-4">We are at the forefront of AI development in computer vision technology.</p>
                        <a href="#" className="text-brand-red text-sm uppercase tracking-widest font-semibold flex items-center gap-2">Learn More <ArrowRight size={14}/></a>
                    </div>
               </div>
               <div className="text-center md:text-left">
                    <div className="flex flex-col items-center md:items-start gap-4">
                        <div className="p-4 border border-white/10 rounded-xl inline-block mb-4">
                            <Settings size={48} strokeWidth={1} />
                        </div>
                        <h3 className="text-2xl font-display font-bold mb-2">AI Recommendation System</h3>
                        <p className="text-secondary text-sm mb-4">Unlocking Intelligent Recommendations with Diseño Pinnacle AI Development.</p>
                        <a href="#" className="text-brand-red text-sm uppercase tracking-widest font-semibold flex items-center gap-2">Learn More <ArrowRight size={14}/></a>
                    </div>
               </div>
          </div>
      </section>

      {/* COLLABORATE SECTION */}
      <section className="py-32 px-6 md:px-12 bg-black relative">
          <div className="max-w-7xl mx-auto">
              <div className="text-center mb-24">
                  <h2 className="text-brand-red text-3xl md:text-5xl font-display font-bold mb-6">Collaborate with Us</h2>
                  <p className="text-secondary max-w-3xl mx-auto">As a leading application software development company, we offer innovative solutions tailored for businesses of all sizes.</p>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                  <CollaborateCard 
                      title="Startup" 
                      description="We understand the unique challenges and opportunities that startups face. Our team of AI experts is committed to supporting startups."
                      Icon={Lightbulb}
                  />
                  <CollaborateCard 
                      title="Enterprises" 
                      description="We understand the complex challenges facing enterprises today. Our team of AI experts is committed to helping enterprises."
                      Icon={Monitor}
                  />
                  <CollaborateCard 
                      title="Small And Midsize Business" 
                      description="We believe that AI has the power to transform SMBs and drive sustainable growth. Our team of AI experts is dedicated to helping SMBs."
                      Icon={Target}
                  />
              </div>
          </div>
      </section>

      {/* TECHNOLOGY SECTION */}
      <section id="technology" className="py-32 px-6 md:px-12 bg-[#080808]">
          <div className="max-w-6xl mx-auto">
               <div className="mb-24 text-center">
                  <RevealText>
                      <h2 className="text-brand-red font-display text-4xl md:text-6xl font-bold mb-4">Technology Stack</h2>
                  </RevealText>
                  <p className="text-secondary max-w-2xl mx-auto mt-6">At Diseño Pinnacle, we prioritize the careful selection of a technology stack to ensure the robust performance of the software applications we develop.</p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-x-16 gap-y-8">
                  <TechItem 
                      title="FastAPI" 
                      description="We harness the power of Python FastAPI to accelerate AI development and deliver innovative solutions."
                      Icon={Zap}
                  />
                   <TechItem 
                      title="Microsoft Azure" 
                      description="We specialize in developing AI solutions powered by Microsoft Azure, the leading cloud platform."
                      Icon={Cloud}
                  />
                   <TechItem 
                      title="Amazon Web Service" 
                      description="We are at the forefront of innovation, seamlessly integrating Amazon Web Services (AWS)."
                      Icon={Server}
                  />
                  <TechItem 
                      title="Redis" 
                      description="We are at the forefront of innovation, harnessing the latest advancements to transform businesses."
                      Icon={Database}
                  />
                   <TechItem 
                      title="Open AI" 
                      description="OpenAI's Language Model is a testament to the extraordinary capabilities of natural language processing."
                      Icon={Bot}
                  />
                   <TechItem 
                      title="Flutter" 
                      description="Top Flutter developers in our team have extensive knowledge and experience in creating apps."
                      Icon={Smartphone}
                  />
                  <TechItem 
                      title="Claude 3" 
                      description="We're pioneers in pushing the boundaries of innovation through our cutting-edge technology stack, Claude 3 LLM."
                      Icon={Lightbulb}
                  />
                  <TechItem 
                      title="LLaVa" 
                      description="At the core of our success lies the LLaVa Models - a proprietary technology stack meticulously crafted."
                      Icon={Layers}
                  />
              </div>
          </div>
      </section>

      {/* FAQ SECTION */}
      <section id="faq" className="py-32 px-6 md:px-12 bg-black">
          <div className="max-w-4xl mx-auto">
              <div className="mb-24 text-center">
                  <RevealText>
                      <h2 className="text-brand-red font-display text-5xl md:text-6xl font-bold mb-4">FAQ's</h2>
                  </RevealText>
              </div>

              <div className="space-y-4">
                  <AccordionItem 
                      question="Do you offer flexible pricing options for AI development services?" 
                      answer="Yes, we understand that every project is unique, and we offer flexible pricing options to accommodate the specific needs and budget constraints of our clients. We work closely with our clients to determine the most cost-effective approach for their projects."
                      isOpen={openFaq === 0}
                      onClick={() => setOpenFaq(openFaq === 0 ? null : 0)}
                  />
                  <AccordionItem 
                      question="Do you provide support and maintenance for AI solutions after deployment?" 
                      answer="Yes, we provide comprehensive post-deployment support and maintenance packages to ensure your AI solutions continue to perform optimally and evolve with your business."
                      isOpen={openFaq === 1}
                      onClick={() => setOpenFaq(openFaq === 1 ? null : 1)}
                  />
                   <AccordionItem 
                      question="How do you ensure the security and privacy of data in AI development?" 
                      answer="Data privacy and security are our top priorities. We adhere to strict data protection regulations and implement robust security measures including encryption and secure access protocols."
                      isOpen={openFaq === 2}
                      onClick={() => setOpenFaq(openFaq === 2 ? null : 2)}
                  />
                   <AccordionItem 
                      question="Can you integrate AI solutions with existing systems or platforms?" 
                      answer="Absolutely. Our team specializes in seamless integration of AI capabilities into legacy systems, modern web apps, and mobile platforms using robust APIs."
                      isOpen={openFaq === 3}
                      onClick={() => setOpenFaq(openFaq === 3 ? null : 3)}
                  />
              </div>
          </div>
      </section>

      {/* CONTACT SECTION */}
      <section id="contact" className="py-32 px-6 md:px-12 bg-black border-t border-white/10">
          <div className="max-w-6xl mx-auto">
              <div className="text-center mb-16">
                  <h2 className="text-brand-red font-display text-5xl font-bold mb-4">Contact Us</h2>
                  <p className="text-secondary">Contact us, we will get back to you ASAP!</p>
              </div>

              <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
                  {/* Contact Info Card */}
                  <div className="lg:col-span-4 bg-black border border-white/10 rounded-xl p-8 h-full flex flex-col justify-center">
                      <h4 className="text-white font-bold text-xl mb-2">Email:</h4>
                      <p className="text-brand-red">info@disenopinnacle.com</p>
                  </div>

                  {/* Contact Form */}
                  <div className="lg:col-span-8">
                      <form className="space-y-6">
                          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                              <div className="space-y-2">
                                  <input 
                                    type="text" 
                                    placeholder="Name*" 
                                    className="w-full bg-black border border-white/20 rounded-lg px-4 py-3 text-white placeholder:text-secondary/50 focus:outline-none focus:border-brand-red transition-colors"
                                  />
                              </div>
                              <div className="space-y-2">
                                  <input 
                                    type="email" 
                                    placeholder="Email*" 
                                    className="w-full bg-black border border-white/20 rounded-lg px-4 py-3 text-white placeholder:text-secondary/50 focus:outline-none focus:border-brand-red transition-colors"
                                  />
                              </div>
                          </div>
                          <div>
                              <textarea 
                                rows={6}
                                placeholder="Write Your Message*"
                                className="w-full bg-black border border-white/20 rounded-lg px-4 py-3 text-white placeholder:text-secondary/50 focus:outline-none focus:border-brand-red transition-colors resize-none"
                              ></textarea>
                          </div>
                          <button className="px-8 py-3 border border-brand-red text-brand-red rounded-full hover:bg-brand-red hover:text-white transition-all duration-300 uppercase text-sm tracking-widest font-semibold">
                              Send Message
                          </button>
                      </form>
                  </div>
              </div>
          </div>
      </section>

      {/* FOOTER */}
      <footer className="py-12 px-6 md:px-12 bg-black relative overflow-hidden">
          <div className="h-px w-full bg-gradient-to-r from-transparent via-brand-red to-transparent mb-12 opacity-50"></div>
          <div className="max-w-7xl mx-auto relative z-10 flex flex-col md:flex-row justify-between items-center gap-8">
              <div className="text-center md:text-left">
                  <h3 className="text-brand-red font-display text-3xl font-bold mb-2">Diseño Pinnacle</h3>
                  <p className="text-white/60 text-xs uppercase tracking-widest">AI Developement Company In Kochi</p>
                  <p className="text-brand-red mt-4 text-sm">Follow me</p>
                  <div className="flex gap-4 mt-4 justify-center md:justify-start">
                      <a href="#" className="text-white hover:text-brand-red transition-colors"><Twitter size={18} /></a>
                      <a href="#" className="text-white hover:text-brand-red transition-colors"><Facebook size={18} /></a>
                      <a href="#" className="text-white hover:text-brand-red transition-colors"><Instagram size={18} /></a>
                      <a href="#" className="text-white hover:text-brand-red transition-colors"><Linkedin size={18} /></a>
                  </div>
              </div>
              
              <button 
                onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
                className="w-12 h-12 rounded-full bg-brand-red flex items-center justify-center text-white hover:scale-110 transition-transform"
              >
                  <ArrowUp size={20} />
              </button>
          </div>
      </footer>
    </div>
  );
};

export default App;