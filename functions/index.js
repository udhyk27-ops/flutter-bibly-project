const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const { GoogleGenerativeAI } = require("@google/generative-ai");

const geminiApiKey = defineSecret("GEMINI_API_KEY");

exports.askBible = onRequest(
  { secrets: [geminiApiKey] },
  async (req, res) => {
    // CORS
    res.set("Access-Control-Allow-Origin", "*");
    if (req.method === "OPTIONS") {
      res.set("Access-Control-Allow-Methods", "POST");
      res.set("Access-Control-Allow-Headers", "Content-Type");
      return res.status(204).send("");
    }

    try {
      const { verse, question } = req.body;

      if (!verse || !question) {
        return res.status(400).json({ error: "verse와 question이 필요합니다." });
      }

      const genAI = new GoogleGenerativeAI(geminiApiKey.value());
      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

      const prompt = `
당신은 성경 말씀을 깊이 이해하는 신학적 AI 도우미입니다.
사용자의 질문에 대해 사용자가 사용한 언어로 답변해주세요.

[성경 구절]
${verse}

[사용자 질문]
${question}

위 구절을 바탕으로 질문에 성실하고 따뜻하게 답변해주세요.
      `;

      const result = await model.generateContent(prompt);
      const answer = result.response.text();

      return res.status(200).json({ answer });
    } catch (error) {
      console.error("Gemini API 오류:", error);
      return res.status(500).json({ error: "AI 응답 중 오류가 발생했습니다." });
    }
  }
);