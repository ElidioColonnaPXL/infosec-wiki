# DLL and hijack

Windows Event Logs and Finding Evil

## 🧩 What is a DLL?

### 🔹 DLL = **Dynamic Link Library**

A **DLL file** is a type of Windows file (`.dll`) that contains **reusable code**, data, or resources that programs can use **without duplicating that code** in every executable.

---

### 📌 Key Points:

- DLLs are **shared libraries** used by multiple applications.

- They help reduce file size, improve modularity, and allow for code reuse.

- The Windows system and many apps use DLLs heavily. For example:

    - `user32.dll` – handles Windows GUI elements.

    - `wpfgfx_v0400.dll` – used by WPF (Windows Presentation Foundation) for graphics rendering.


---

### 🏗️ Example:

Instead of putting graphic rendering code into every app, Microsoft puts it in `wpfgfx_v0400.dll`, and many apps just "call" it when needed.

---

## 💣 What is a DLL Hijack?

### 🔹 DLL Hijacking is a **type of attack** where a malicious DLL is loaded **instead of the legitimate one** by exploiting how Windows searches for DLL files.

---

### 🔐 How DLL Hijacking Works:

1. A program tries to load a DLL (e.g., `graphics.dll`), but doesn’t use a full path.

2. Windows searches for the DLL in a specific order:

    - The application directory

    - System directories

    - The PATH environment variable, etc.

3. If an attacker **places a malicious DLL** with the same name in a location Windows searches **before the legitimate path**, the program may load the attacker's DLL.

4. Once loaded, the malicious DLL runs **with the privileges of the vulnerable program** — which could be **Administrator-level**.


---

### 🧠 Analogy:

> Imagine a program asking for a helper tool named `assistant.dll`. It doesn’t care where it comes from — it just grabs the first one it finds. If an attacker sneakily puts a fake `assistant.dll` in the folder the program checks first, the program will use the fake version. Boom — you’ve been hijacked.

---

### 🚨 Why It’s Dangerous:

- The malicious DLL runs **in the context of a trusted application**.

- Can be used for:

    - Gaining elevated privileges

    - Installing backdoors

    - Extracting credentials

    - Maintaining stealth persistence


---

## 🔍 Example:

Let’s say a program in:

```
C:\Program Files\CoolApp\coolapp.exe
```

tries to load:

```
msimg32.dll
```

But doesn’t specify a path. If an attacker places a malicious version of `msimg32.dll` in the same folder as `coolapp.exe`, the app may load it — and run the attacker’s code.

---

## 🛡️ Defenses Against DLL Hijacking:

- Use **fully qualified paths** when loading DLLs.

- Use `SetDllDirectory` and `LoadLibraryEx` with safe flags.

- Sign and verify DLLs.

- Restrict write access to sensitive folders.

- Monitor file and process behavior (EDR, auditing, etc.).
