---
title: "Translation"
---

Leverage translation services and the GPT-4o model to interpret customer feedback across various languages.

There is a `Translation` page located here(`apps\web\pages\translation\Translation.tsx`) on the website. The page has an input textbox for user review, and a button to invoke AI Service and get back translated review.

1- Navigate to the page via `Explorer` and click the file to open it in the editor.

2- Replace all text in the file with below code. 

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

        const translation_url = `https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=fr&from=en`;
        const translation_key = "3e5021bdb65d4599805fd20a56b201aa";

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

3- Once copied, the web page in the browser should auto refresh, please test out the function.

4- Feel free to expand on it to make it more interesting!
