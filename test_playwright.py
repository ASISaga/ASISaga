"""Test script to verify Playwright browser installation."""
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    print("Playwright browsers available:")
    print(f"  Chromium: {p.chromium.name}")
    print(f"  Firefox: {p.firefox.name}")
    print(f"  WebKit: {p.webkit.name}")
    
    # Try to launch a browser
    browser = p.chromium.launch(headless=True)
    print("\n✓ Successfully launched Chromium browser")
    browser.close()
    print("✓ Browser closed successfully")
