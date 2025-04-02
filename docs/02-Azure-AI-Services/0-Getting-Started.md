---
title: Run Website
---

Follow the steps below to set up the lab environment using GitHub Codespaces:

1. Create a GitHub Account if you don't have one already, you can join [here](https://github.com/join).

2. Navigate to the [Azure AI Lab](https://github.com/qkfang/azure-ai-lab) repository in browser. Click on the green `Code` button and select `Codespaces` tab. If you don't see this option, ensure you have logged into your account in browser.

3. Click on `Create codespace` button to create a new development environment. This will set up a Codespace with all the necessary tools and dependencies pre-installed.

4. The Codespace will take a few minutes to set up. It will install the following tools and dependencies for you.

5. Once the Codespace is ready, you can start coding and follow the lab instructions directly within the browser-based VS Code environment. The changes you make in your Codespace are saved automatically. If you stop and restart your Codespace, your changes will persist.

6. For this lab you are using website located in `apps\web`. Open `Terminal` in VS code and navigate to `apps\web` folder.

```bash
cd apps/web
```

7. Install required node packages by running below command

```bash
npm install
```

8. Run the website by running below command

```bash
npm run dev
```

9. If you are running the `codespaces` in web browser, you will  see `Open in browser` popup button asking if you want to open the site in browser. If you missed the button, go to `PORTS` tab to find it.

10. Now you can continue to next step!
