"""Direct web quality check for businessinfinity.asisaga.com"""
import asyncio
from playwright.async_api import async_playwright


async def check_web_quality():
    url = "https://businessinfinity.asisaga.com/"
    
    print(f"# Web Quality Analysis Report for {url}\n")
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        # Track console messages
        console_messages = []
        page.on("console", lambda msg: console_messages.append(msg))
        
        print("Loading page...")
        await page.goto(url, wait_until="networkidle", timeout=30000)
        print("✓ Page loaded\n")
        
        # Check for contrast issues
        print("## Contrast & Color Issues\n")
        
        contrast_issues = await page.evaluate("""
            () => {
                const issues = [];
                
                // Check all elements with background and text
                const elements = document.querySelectorAll('*');
                
                elements.forEach(el => {
                    const styles = window.getComputedStyle(el);
                    const bgColor = styles.backgroundColor;
                    const color = styles.color;
                    
                    // Check if element has white or very light background
                    if (bgColor.includes('255, 255, 255') || bgColor.includes('rgb(255')) {
                        const text = el.textContent?.trim().substring(0, 50);
                        if (text && el.offsetParent) {
                            issues.push({
                                tag: el.tagName,
                                class: el.className,
                                text: text,
                                bgColor: bgColor,
                                color: color
                            });
                        }
                    }
                });
                
                return issues.slice(0, 20); // Return first 20
            }
        """)
        
        if contrast_issues:
            print(f"**Found {len(contrast_issues)} elements with white/light backgrounds:**\n")
            for issue in contrast_issues[:10]:
                print(f"- {issue['tag']}.{issue['class'][:30]}")
                print(f"  Background: {issue['bgColor']}")
                print(f"  Text Color: {issue['color']}")
                print(f"  Content: {issue['text'][:50]}...")
                print()
        
        # Check sections
        print("\n## Section Backgrounds\n")
        
        sections = await page.evaluate("""
            () => {
                const sections = document.querySelectorAll('section');
                return Array.from(sections).map(s => ({
                    class: s.className,
                    bgColor: window.getComputedStyle(s).backgroundColor,
                    id: s.id
                }));
            }
        """)
        
        for section in sections:
            print(f"- Section#{section['id'] or 'unnamed'} .{section['class']}")
            print(f"  Background: {section['bgColor']}\n")
        
        await browser.close()


if __name__ == "__main__":
    asyncio.run(check_web_quality())
