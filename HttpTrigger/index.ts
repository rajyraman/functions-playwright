import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import * as playwright from "playwright";

const httpTrigger: AzureFunction = async function(
  context: Context,
  req: HttpRequest
): Promise<void> {
  context.log("HTTP trigger function processed a request.");
  const name = req.query.name;

  if (name) {
    const browser = await playwright.chromium.launch();
    const browserContext = await browser.newContext({
      viewport: { height: 1080, width: 1920 }
    });
    const page = await browserContext.newPage();
    await page.goto(req.query.name);
    const screenshot = await page.screenshot();
    await browser.close();
    context.res.setHeader("Content-Type", "image/png");
    context.res.body = new Uint8Array(screenshot);
  } else {
    context.res = {
      status: 400,
      body: "Please pass a name on the query string or in the request body"
    };
  }
};

export default httpTrigger;
