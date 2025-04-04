---
title: "SEO"
---

Develop a feature to download a specific web page, convert html to text and summarise it.

There is a `SEO` page located here (`apps\web\pages\seo\Seo.tsx`) on the website. The page has an input textbox for a url, and a button to invoke AI Service and get back a generated SEO content. Use `http://codespaces_url/product.html` for testing (replace `codespaces_url` with actual url of the codespaces website)

1- Navigate to the page via `Explorer` and click the file to open it in the editor.

2- Replace all text in the file with below code. 

```

import React, { useState } from "react";
import { trackPromise } from "react-promise-tracker";
import { usePromiseTracker } from "react-promise-tracker";
import { OpenAIClient, AzureKeyCredential, Completions } from '@azure/openai';


const Page = () => {
    const { promiseInProgress } = usePromiseTracker();
    const [seoUrl, setSeoUrl] = useState<string>();
    const [seoText, setSeoText] = useState<string>("");

    async function process() {
        if (seoUrl != null) {
            trackPromise(
                seoApi(seoUrl)
            ).then((res) => {
                setSeoText(res);
            }
            )
        }
    }

    async function seoApi(url): Promise<string> {
        const response = await fetch(url);
        const html = await response.text();
        console.log(html);

        var messages =
            [
                { "role": "system", "content": "You are a helpful assistant that generate json data based on received xml. output must be json. actually generate the json, don't show me how." },
                {
                    "role": "user", "content": [
                        {
                            "type": "text",
                            "text": "Analyse the provided html and summarise it as a json object containing the following fields  : seoKey, seoTitle, seoDescription. \r\n HTML content is here \r\n" + html
                        }
                    ]
                }
            ];
        console.log(messages);

        const options = {
            api_version: "2024-08-01-preview"
        };

        var openai_url = "https://azureailab-openai.openai.azure.com";
        var openai_key = "9704ddf46e03414ca72ae6f48a6eb56b";
        const client = new OpenAIClient(
            openai_url,
            new AzureKeyCredential(openai_key),
            options
        );
        // ?api-version=2023-12-01-preview
        const deploymentName = 'gpt-4o';
        const result = await client.getChatCompletions(deploymentName, messages, {
            maxTokens: 200,
            temperature: 0.25
        });
        return result.choices[0]?.message?.content ?? '';
    }

    const updateText = (e: React.ChangeEvent<HTMLInputElement>) => {
        setSeoUrl(e.target.value);
    };

    return (
        <div className="pageContainer">
            <h2>SEO</h2>
            <p>Sample product page is here: http://codespaces_url/product.html (replace 'codespaces_url' with actual url of the codespaces website in the browsser address bar)
            </p>
            <p>
                <input type="text" placeholder="(enter url)" onChange={updateText} />
                <button onClick={() => process()}>Generate</button><br />
                {
                    (promiseInProgress === true) ?
                        <span>Loading...</span>
                        :
                        null
                }
            </p>
            <p>
                {seoText}
            </p>
        </div>
    );
};

export default Page;

```

3- Once copied, the web page in the browser should auto refresh, please test out the function.

4- Feel free to expand on it to make it more interesting!
