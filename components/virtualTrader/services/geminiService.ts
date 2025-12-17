const API_KEY = import.meta.env.VITE_GEMINI_API_KEY || import.meta.env.VITE_API_KEY || '';
const API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

interface ChatMessage {
  role: string;
  parts: { text: string }[];
}

export const sendChatMessage = async (message: string, history: ChatMessage[]): Promise<string> => {
  try {
    const systemInstruction = `You are the built-in AI assistant for a Virtual Paper Trading application called "Virtual Trader". 
    Your goal is to help users understand stock market concepts, explain how paper trading works (zero risk), and analyze simple financial terms.
    Keep answers concise, professional, and encouraging. Use currency symbol ₹ where appropriate.
    The app features: Portfolio tracking, Nifty 50/Sensex monitoring, Top Gainers/Losers, and virtual ordering.`;

    const contents = [
      { role: 'user', parts: [{ text: systemInstruction }] },
      { role: 'model', parts: [{ text: 'Understood! I am the Virtual Trader AI assistant, ready to help you learn about stock trading risk-free.' }] },
      ...history,
      { role: 'user', parts: [{ text: message }] }
    ];

    const response = await fetch(`${API_URL}?key=${API_KEY}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        contents,
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: 1024,
        }
      }),
    });

    if (!response.ok) {
      throw new Error(`API error: ${response.status}`);
    }

    const data = await response.json();
    return data.candidates?.[0]?.content?.parts?.[0]?.text || "I couldn't generate a response. Please try again.";
  } catch (error) {
    console.error("Error generating AI response:", error);
    return "I'm having trouble connecting to the market data right now. Please try again later.";
  }
};