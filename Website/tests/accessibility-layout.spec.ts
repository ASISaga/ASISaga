import fs from 'fs';
import path from 'path';
import { AccessibilityTestSuite, Subdomain } from '../../Buddhi/src/Buddhi/node/tests_playwright/accessibilityTestSuite';

function loadSubdomainData(filename: string): Subdomain {
    const filePath = path.resolve(__dirname, 'data', filename);
    const raw = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(raw);
}

const suite = new AccessibilityTestSuite();


// Change these filenames to test different subdomains
const subdomainMain: Subdomain = loadSubdomainData('main-site.json');
suite.runAllTests(subdomainMain);

const subdomainBI: Subdomain = loadSubdomainData('business-infinity.json');
suite.runAllTests(subdomainBI);

const subdomainROA: Subdomain = loadSubdomainData('realm-of-agents.json');
suite.runAllTests(subdomainROA);
