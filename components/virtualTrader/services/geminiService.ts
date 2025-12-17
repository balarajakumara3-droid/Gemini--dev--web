import { GoogleGenAI } from "@google/genai";

const apiKey = import.meta.env.VITE_GEMINI_API_KEY || import.meta.env.VITE_API_KEY || '';
const ai = new GoogleGenAI({ apiKey });

export const sendChatMessage = async (message: string, history: { role: string; parts: { text: string }[] }[]) => {
  try {
    const model = 'gemini-2.5-flash';
    const systemInstruction = `You are the built-in AI assistant for a Virtual Paper Trading application called "Virtual Trader". 
    Your goal is to help users understand stock market concepts, explain how paper trading works (zero risk), and analyze simple financial terms.
    Keep answers concise, professional, and encouraging. Use currency symbol ₹ where appropriate.
    The app features: Portfolio tracking, Nifty 50/Sensex monitoring, Top Gainers/Losers, and virtual ordering.`;

    const chat = ai.chats.create({
      model,
      config: {
        systemInstruction,
      },
      history: history, // Pass previous context if needed, though for this simple demo we might just send the prompt
    });

    const result = await chat.sendMessage({ message });
    return result.text;
  } catch (error) {
    console.error("Error generating AI response:", error);
    return "I'm having trouble connecting to the market data right now. Please try again later.";
  }
};