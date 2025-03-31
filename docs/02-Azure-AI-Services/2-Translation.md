---
title: "Translation"
---

Leverage translation services and the GPT-4o model to interpret customer feedback across various languages, enabling efficient summarization and in-depth analysis for data-driven decision-making.​

There is a `Translation` page (`apps\web\pages\translation\Translation.tsx`) on chatbot. The page has an input textbox for user review, and a button to invoke AI Service and get back translated review.

Open above page in `VS Code` and replace the whole file with below code. 

```
import React, { useState } from "react";
import { trackPromise } from "react-promise-tracker";
import { usePromiseTracker } from "react-promise-tracker";

const Page = () => {

    const { promiseInProgress } = usePromiseTracker();
    const [orginalText, setOriginalText] = useState<string>();
    const [translatedText, setTranslatedText] = useState<string>("");

    async function process() {
        if (orginalText != null) {
            trackPromise(
                translationApi(orginalText)
            ).then((res) => {
                setTranslatedText(res);
            }
            )
        }
    }

    async function translationApi(text: string): Promise<string> {

        const translation_url = `https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=en&from=fr`;
        const translation_key = "<API_KEY>";

        const body =
            [{
                "text": `${text}`
            }];

        const response = await fetch(translation_url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Ocp-Apim-Subscription-Region": "eastus",
                "Ocp-Apim-Subscription-Key": translation_key,
            },
            body: JSON.stringify(body),
        });
        const data = await response.json();
        return data[0].translations[0].text;
    }

    const updateText = (e: React.ChangeEvent<HTMLInputElement>) => {
        setOriginalText(e.target.value);
    };

    return (
        <div className="pageContainer">
            <h2>Translation</h2>
            <p></p>
            <p>
                <input type="text" placeholder="(enter review in original language)" onChange={updateText} />
                <button onClick={() => process()}>Translate</button><br />
                {
                    (promiseInProgress === true) ?
                        <span>Loading...</span>
                        :
                        null
                }
            </p>
            <p>
                {translatedText}
            </p>
        </div>
    );
};

export default Page;

```

Once copied, the web page in the browser should auto refresh, please test out the function!

Feel free to expand on it to make it more interesting!
