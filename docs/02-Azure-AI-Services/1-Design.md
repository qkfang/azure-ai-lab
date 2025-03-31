---
title: "Design"
---

Use Dall-e model to create cretivity product design based on user's description.

There is a `Design` page (`apps\web\pages\design\Design.tsx`) on chatbot. The page has an input textbox for description, and a button to call AI Service and get back a generated image.

Open above page in `VS Code` and replace the whole file with below code. 


```

import React, { useState } from "react";
import { trackPromise } from "react-promise-tracker";
import { usePromiseTracker } from "react-promise-tracker";
import { OpenAIClient, AzureKeyCredential, Completions } from '@azure/openai';

const Page = () => {

    const { promiseInProgress } = usePromiseTracker();
    const [imageText, setImageText] = useState<string>();
    const [imageUrl, setImageUrl] = useState<string>("");

    async function process() {
        if (imageText != null) {
            trackPromise(
                dalleApi(imageText)
            ).then((res) => {
                setImageUrl(res);
            }
            )
        }
    }

    async function dalleApi(prompt: string): Promise<string> {
        const options = {
            api_version: "2024-02-01"
        };
        const size = '1024x1024';
        const n = 1;
        
        var openai_url = "https://azureailab-openai.openai.azure.com";
        var openai_key = "9704ddf46e03414ca72ae6f48a6eb56b";
        const client = new OpenAIClient(
            openai_url,
            new AzureKeyCredential(openai_key),
            options
        );

        const deploymentName = 'dalle-3';
        const result = await client.getImages(deploymentName, prompt, { n, size });
        console.log(result);

        if (result.data[0].url) {
            return result.data[0].url;
        } else {
            throw new Error("Image URL is undefined");
        }
    }

    const updateText = (e: React.ChangeEvent<HTMLInputElement>) => {
        setImageText(e.target.value);
    };

    return (
        <div className="pageContainer">
            <h2>Design</h2>
            <p></p>
            <p>
                <input type="text" placeholder="(describe your design here)" onChange={updateText} />
                <button onClick={() => process()}>Generate</button><br />
                {
                    (promiseInProgress === true) ?
                        <span>Loading...</span>
                        :
                        null
                }
            </p>
            <p>
                <img height={"550px"} src={imageUrl} />
            </p>
        </div>
    );
};

export default Page;

```

Once copied, the web page in the browser should auto refresh, please test out the function!

Feel free to expand on it to make it more interesting!
