## 📝 1. Headings

Use `#` for headings (1–6 levels).

`# Heading 1 ## Heading 2 ### Heading 3 #### Heading 4 ##### Heading 5 ###### Heading 6`

**Preview:**

# Heading 1

## Heading 2

### Heading 3

---

## 💬 2. Text Formatting

|Style|Syntax|Example|
|---|---|---|
|**Bold**|`**bold**` or `__bold__`|**bold**|
|_Italic_|`*italic*` or `_italic_`|_italic_|
|_**Bold + Italic**_|`***text***`|_**text**_|
|~~Strikethrough~~|`~~text~~`|~~text~~|
|==Highlight==|`==text==` _(Obsidian only)_|==highlight==|
|`Inline code`|`` `code` ``|`code`|

---

## 📦 3. Lists

### • Unordered List

`- Item 1 - Item 2    - Sub-item * Another item`

### • Ordered List

`1. First 2. Second    1. Nested`

---

## ✅ 4. Task Lists

`- [ ] Incomplete task - [x] Completed task`

**Preview:**

-  Incomplete task

-  Completed task


---

## 🔗 5. Links

### External Links

`[OpenAI](https://openai.com)`

### Internal Links (Obsidian)

`Note Name Note Name Custom Label`

---

## 🖼️ 6. Images

`> [!missing] Missing source attachment: `image.png`          <!-- Embed from vault -->   <!-- Web image -->`

---

## 🗃️ 7. Blockquotes

`> This is a quote. >> Nested quote.`

**Preview:**

> This is a quote.
>
> > Nested quote.

---

## 💻 8. Code Blocks

### Inline

`` `inline code` `` → `inline code`

### Multi-line

<pre><code>```python def greet(): print("Hello, Obsidian!") ```</code></pre>

**Preview:**

`def greet():     print("Hello, Obsidian!")`

---

## 📋 9. Tables

`| Name | Age | Role | |------|-----|------| | Alice | 25 | Dev | | Bob | 30 | Writer |`

**Preview:**

|Name|Age|Role|
|---|---|---|
|Alice|25|Dev|
|Bob|30|Writer|

---

## 📣 10. Callouts (Obsidian Feature)

`> [!note] > This is a note.  > [!warning] > Be careful here!  > [!tip] > Use callouts for emphasis.`

**Preview:**

> **Note:**
> This is a note.

> **Warning:**
> Be careful here!

> **Tip:**
> Use callouts for emphasis.

---

## ⏫ 11. Footnotes

`Here’s a fact.[^1]  [^1]: This is the footnote text.`

---

## 🧱 12. Horizontal Rule

`---`

---

## 🔁 13. Embeds

Embed notes, images, PDFs, or audio:

`> [!missing] Missing source attachment: `Note Name` > [!missing] Missing source attachment: `Note Name` > [!missing] Missing source attachment: `file.pdf` > [!missing] Missing source attachment: `audio.mp3``

---

## 🧩 14. Comments

Obsidian ignores HTML comments.

`<!-- This won’t appear in preview -->`

---

## 🧮 15. Math (LaTeX)

Inline:

`$E = mc^2$`

Block:

`$$ \int_a^b f(x)\,dx $$`

---

## 🪶 16. Tags

Tags are simple keywords with `#`:

`#project #idea #obsidian`

---

## 🧠 17. Dataview & Plugins (Advanced)

If you use **Dataview**, you can query notes:

` ```dataview TABLE date, status FROM #project SORT date DESC `
