# Priority Issues & Bug Fixes

**Status:** Ready for systematic fix
**Last Updated:** 2025-11-01

---

## 🔴 CRITICAL BUGS (Fix Immediately)

### 1. Eisenhauer - Page Not Responsive & Console Error
**Severity:** 🔴 CRITICAL
**Project:** Eisenhauer (PWA)
**Description:**
- Page doesn't respond/show tasks
- Page title (h1) is struck through
- Console error: `Unhandled Promise Rejection: TypeError: null is not an object (evaluating 'userInfo.textContent = '')`
- App is completely broken

**Root Cause:** Null reference error in userInfo object access

**Required Fix:**
1. Find where `userInfo.textContent` is being set
2. Add null checks before accessing textContent
3. Verify all DOM elements are properly initialized
4. Test that tasks appear and page is interactive

**Files to Check:**
- `auth.js` - Authentication and user info handling
- `js/modules/ui.js` - UI initialization
- `index.html` - HTML structure for userInfo element

---

## 🟠 HIGH PRIORITY ISSUES

### 2. 1x1Trainer - Missing Dark Mode Toggle in Settings
**Severity:** 🟠 HIGH
**Project:** 1x1_Trainer (React Native/Expo)
**Description:**
- Settings menu exists but is missing dark mode/light mode toggle
- Missing version display
- Should match Pflanzkalender pattern

**Required Fix:**
1. Add dark mode toggle (Dark/System/Light) in settings menu
2. Add version display (match 1x1_Trainer version)
3. Follow Pflanzkalender component structure
4. Add language toggle (if applicable)

**Reference Pattern:** See Pflanzkalender SettingsScreen for implementation

---

### 3. EnergyPriceGermany - Remove Emojis & Clean Up Settings
**Severity:** 🟠 HIGH
**Project:** EnergyPriceGermany (React Native)
**Description:**
- Settings menu contains emojis (violates ux-vorgaben)
- GitHub repository link should be removed
- Footer section should be completely removed
- "Support the Project" text should be "Buy Me a Coffee"

**Required Fix:**
1. Remove all emojis from settings menu
   - ❌ Remove "📈 Metriken anzeigen"
   - ❌ Remove "🔗 GitHub Repository"
   - ❌ Remove "💝 Support the Project"
2. Keep only:
   - Dark/Light/System theme toggle
   - Feedback link (no emoji)
   - About/Version info (no emoji)
   - "Buy Me a Coffee" link (no emoji)
3. Remove entire footer section
4. Clean up styles

---

## 🟡 STANDARDIZATION ISSUES

### 4. Inconsistent Settings Menu Structure
**Severity:** 🟡 MEDIUM
**Projects:** All 5 projects
**Description:**
- Each project has different settings menu structure
- No consistent ordering or styling
- Need unified approach per ux-vorgaben

**Required Fix:**
All settings menus should have **in this exact order**:

```
1. DISPLAY SETTINGS
   - Dark Mode toggle (Dark/System/Light)
   - Language toggle (if applicable)

2. FEEDBACK
   - "Send Feedback" link (mailto: or form)

3. ABOUT
   - License & Version info
   - "© 2025 Sven Strohkark"

4. SUPPORT
   - "Buy Me a Coffee" link (https://buymeacoffee.com/sven4321)
```

**All items in one line style (like Pflanzkalender)**

---

## 📋 Detailed Issues by Project

### **1x1_Trainer**

**Issue 1.1:** Missing Dark Mode Toggle
- [ ] Add dark mode state management
- [ ] Add toggle buttons (Dark/System/Light)
- [ ] Persist preference to localStorage/AsyncStorage
- [ ] Add version display next to dark mode

**Issue 1.2:** Settings Menu Incomplete
- [ ] Add language toggle (if translations exist)
- [ ] Add feedback link
- [ ] Add about/version info
- [ ] Add Buy Me a Coffee link

**Issue 1.3:** Remove Emojis
- [ ] Check all UI text for emojis
- [ ] Remove if found

---

### **EnergyPriceGermany**

**Issue 2.1:** Remove GitHub Link
- [ ] Find and remove GitHub repository link from settings
- [ ] Find where it's defined in code
- [ ] Test that it no longer appears

**Issue 2.2:** Remove Footer Section
- [ ] Remove entire footer from render
- [ ] Remove footer styles
- [ ] Remove footer-related state

**Issue 2.3:** Clean Up Emojis
- [ ] Remove 📈 from metrics
- [ ] Remove 🔗 from GitHub link (already removing link)
- [ ] Remove 💝 from support link
- [ ] Update all menu item text to plain text

**Issue 2.4:** Standardize Settings Menu
- [ ] Add dark mode toggle (if not exists)
- [ ] Add feedback link
- [ ] Add about/version info
- [ ] Reorganize in standard order

---

### **Eisenhauer**

**Issue 3.1:** CRITICAL - Fix null userInfo Error
- [ ] Find `userInfo` DOM element reference
- [ ] Add null check before accessing `.textContent`
- [ ] Verify element exists in HTML
- [ ] Test that page loads and responds

**Issue 3.2:** CRITICAL - Fix Struck Through Title
- [ ] Check CSS for text-decoration: line-through on h1
- [ ] Remove or fix strikethrough styling
- [ ] Verify title displays normally

**Issue 3.3:** CRITICAL - Tasks Not Showing
- [ ] Check if data is loading
- [ ] Check if DOM elements are being created
- [ ] Check console for other errors
- [ ] Test with sample data

**Issue 3.4:** Standardize Settings Menu
- [ ] Update auth.js to include all required settings
- [ ] Add dark mode toggle
- [ ] Add feedback link
- [ ] Add about/version info
- [ ] Add Buy Me a Coffee link

---

### **Pflanzkalender**

**Status:** ✅ MOSTLY GOOD
- ✅ Has correct settings structure
- ✅ Has dark mode toggle
- ✅ Has feedback link
- ✅ Has about info
- ✅ Has Buy Me a Coffee link
- ✅ No emojis

**Issue 4.1:** Verify Consistency
- [ ] Double-check structure matches new standard
- [ ] Verify all text is plain (no emojis)
- [ ] Test all links work

---

### **CD-to-Spotify-PWA**

**Status:** ℹ️ EARLY DEVELOPMENT
- Still in development phase
- Will implement standard structure when ready
- Use Pflanzkalender as reference

---

## 🛠️ Fix Priority Order

**Week 1:**
1. ✅ Create this document
2. 🔴 Fix Eisenhauer bugs (CRITICAL - blocks app)
3. 🟠 Fix 1x1Trainer dark mode & version
4. 🟠 Fix EnergyPriceGermany cleanup

**Week 2:**
5. 🟡 Update UX-vorgaben.md with new standard
6. 🟡 Implement consistent settings across all projects
7. ✅ Test all projects thoroughly
8. ✅ Commit and document changes

---

## ✅ Verification Checklist

After all fixes:

- [ ] Eisenhauer loads without errors
- [ ] Eisenhauer displays tasks correctly
- [ ] 1x1Trainer has dark mode toggle in settings
- [ ] 1x1Trainer shows version number
- [ ] EnergyPriceGermany has no emojis
- [ ] EnergyPriceGermany has no GitHub link
- [ ] EnergyPriceGermany has no footer
- [ ] All projects have identical settings menu structure
- [ ] All projects use same settings order
- [ ] No emojis in any project
- [ ] All dark mode toggles work
- [ ] All feedback links work
- [ ] All support links work
- [ ] UX-vorgaben.md updated with standard

---

## 📝 Notes

### Eisenhauer Error Details
```
Unhandled Promise Rejection: TypeError: null is not an object
(evaluating 'userInfo.textContent = ''')
```

This indicates:
- `userInfo` is null (element not found or not initialized)
- Code tries to set textContent without checking
- Likely in auth.js or ui.js initialization

### Settings Menu Standard
**Reference Implementation:** Pflanzkalender SettingsScreen.tsx
- Clean, simple structure
- No emojis
- Proper spacing
- Dark mode toggle + theme colors
- Language option
- Feedback link
- About section
- Support link

---

## 🎯 Success Criteria

✅ All projects load without errors
✅ All projects have identical settings menu (same order, same structure)
✅ No emojis anywhere in UI
✅ Dark mode toggles functional
✅ All links working
✅ Console clean (no errors)
✅ UX-vorgaben.md updated & accurate
✅ All commits pushed to GitHub

---

**Ready to start fixing!** 🚀
