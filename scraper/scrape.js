const puppeteer = require('puppeteer');
const fs = require('fs');

const url = process.env.SCRAPE_URL || 'https://example.com';

(async () => {
    const browser = await puppeteer.launch({
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    const page = await browser.newPage();
    await page.goto(url, { waitUntil: 'domcontentloaded' });

    const data = {
        title: await page.title(),
        heading: await page.$eval('h1', el => el.innerText)
    };

    await browser.close();
    fs.writeFileSync('/app/scraped_data.json', JSON.stringify(data, null, 2));
})();

