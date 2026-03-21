const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const { initializeApp } = require("firebase-admin/app");
const { getRemoteConfig } = require("firebase-admin/remote-config");

initializeApp();

const geminiApiKey = defineSecret("GEMINI_API_KEY");

// Remote Config에서 aiModel 가져오기
async function getAiModel() {
  try {
    const rc = getRemoteConfig();
    const template = await rc.getTemplate();
    return template.parameters?.aiModel?.defaultValue?.value ?? "gemini-2.5-flash-lite";
  } catch (e) {
    return "gemini-2.5-flash-lite";
  }
}

exports.askBible = onRequest(
  { secrets: [geminiApiKey] },
  async (req, res) => {
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

      const aiModel = await getAiModel();
      const genAI = new GoogleGenerativeAI(geminiApiKey.value());
      const model = genAI.getGenerativeModel({ model: aiModel });

      const prompt = verse
        ? `
당신은 성경 말씀을 깊이 이해하는 신학적 AI 도우미입니다.
사용자의 질문에 대해 사용자가 사용한 언어로 답변해주세요.

[성경 구절]
${verse}

[사용자 질문]
${question}

위 구절을 바탕으로 질문에 성실하고 따뜻하게 답변해주세요.
        `
        : `
당신은 성경 말씀을 깊이 이해하는 신학적 AI 도우미입니다.
사용자의 질문에 대해 사용자가 사용한 언어로 답변해주세요.

[사용자 질문]
${question}

성실하고 따뜻하게 답변해주세요.
        `;

      const result = await model.generateContent(prompt);
      return res.status(200).json({ answer: result.response.text() });
    } catch (error) {
      console.error("Gemini API 오류:", error);
      return res.status(500).json({ error: "AI 응답 중 오류가 발생했습니다." });
    }
  }
);

exports.getBibleStory = onRequest(
  { secrets: [geminiApiKey] },
  async (req, res) => {
    res.set("Access-Control-Allow-Origin", "*");
    if (req.method === "OPTIONS") {
      res.set("Access-Control-Allow-Methods", "POST");
      res.set("Access-Control-Allow-Headers", "Content-Type");
      return res.status(204).send("");
    }

    try {
      const { bookName } = req.body;
      if (!bookName) {
        return res.status(400).json({ error: "bookName이 필요합니다." });
      }

      const aiModel = await getAiModel();
      const genAI = new GoogleGenerativeAI(geminiApiKey.value());
      const model = genAI.getGenerativeModel({ model: aiModel },);

      const stories = [
        '가장 드라마틱한 사건이나 반전',
        '잘 알려지지 않은 숨겨진 이야기',
        '주요 인물의 실수나 갈등',
        '당시 시대적 배경과 문화',
        '하나님과 인간의 특별한 만남',
      ];
      const angle = stories[Math.floor(Math.random() * stories.length)];

      const prompt = `
      성경 "${bookName}"에서 실제로 있었던 흥미로운 이야기를 아래 JSON 형식으로만 답변해주세요.
      마크다운, 코드블록, 설명 없이 JSON만 출력하세요.

      관점: ${angle}

      {
        "title": "흥미로운 제목 (질문형이나 호기심 유발 형태로)",
        "content": "해당 이야기를 쉽고 흥미롭게 3~4문장으로 설명",
        "reference": "관련 구절 (장:절)"
      }
      `;

      const result = await model.generateContent(prompt);
      let text = result.response.text().trim();

      // 마크다운 코드블록 제거
      text = text.replace(/```json/g, '').replace(/```/g, '').trim();

      const json = JSON.parse(text);

      return res.status(200).json(json);
    } catch (error) {
      console.error("Gemini API 오류:", error);
      return res.status(500).json({ error: "AI 응답 중 오류가 발생했습니다." });
    }
  }
);