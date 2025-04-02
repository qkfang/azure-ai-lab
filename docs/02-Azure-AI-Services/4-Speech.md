---
title: "Speech"
---

Invoke Azure Speech service to read out text content in voice (text to speech).

There is a `Speech` page located here (`apps\web\pages\speech\Speech.tsx`) on the website. The page has an input textbox for text content, and a button to invoke AI Service and play voice output.

1- Navigate to the page via `Explorer` and click the file to open it in the editor.

2- Replace all text in the file with below code. 

```

import React, { useState, useEffect } from "react";
import { trackPromise } from "react-promise-tracker";
import { usePromiseTracker } from "react-promise-tracker";
import * as sdk from 'microsoft-cognitiveservices-speech-sdk';


const Page = () => {

    const { promiseInProgress } = usePromiseTracker();
    const [speechText, setSpeechText] = useState<string>();
    const synthesizer = React.useRef(null);
    const speechConfig = React.useRef(null);

    useEffect(() => {
        const speech_key = '843fc486ceb047129d416be20e57073b';
        speechConfig.current = sdk.SpeechConfig.fromSubscription(
            speech_key,
            'eastus'
        );
        speechConfig.current.speechRecognitionLanguage = 'en-US';
        // speechConfig.current.speechSynthesisOutputFormat = 5;
        synthesizer.current = new sdk.SpeechSynthesizer(
            speechConfig.current
        );

    }, []);

    async function process() {
        if (speechText != null) {
            trackPromise(
                speechApi(speechText)
            ).then((res) => {
                
            }
            )
        }
    }

    async function speechApi(text: string): Promise<string> {
        await synthesizer.current.speakTextAsync(
            text,
            result => {
                synthesizer.close();
                const { audioData } = result;
                // return stream from memory
                const bufferStream = new PassThrough();
                bufferStream.end(Buffer.from(audioData));
                resolve(bufferStream);
            },
            error => {
                synthesizer.close();
                reject(error);
            });
    }

    const updateText = (e: React.ChangeEvent<HTMLInputElement>) => {
        setSpeechText(e.target.value);
    };

    return (
        <div className="pageContainer">
            <h2>Speech</h2>
            <p></p>
            <p>
                <input type="text" placeholder="(enter some text to be read aloud)" onChange={updateText} />
                <button onClick={() => process()}>Read</button><br />
                {
                    (promiseInProgress === true) ?
                        <span>Loading...</span>
                        :
                        null
                }
            </p>
        </div>
    );
};

export default Page;

```

3- Once copied, the web page in the browser should auto refresh, please test out the function.

4- Feel free to expand on it to make it more interesting!
