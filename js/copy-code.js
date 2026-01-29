/**
 * Add copy button to code blocks
 */
(function() {
  'use strict';

  if (!document.queryCommandSupported('copy')) {
    return;
  }

  function flashCopyMessage(el, msg) {
    el.textContent = msg;
    setTimeout(function() {
      el.textContent = "Copy";
    }, 1000);
  }

  function selectText(node) {
    var selection = window.getSelection();
    var range = document.createRange();
    range.selectNodeContents(node);
    selection.removeAllRanges();
    selection.addRange(range);
    return selection;
  }

  function addCopyButton(containerEl) {
    var copyBtn = document.createElement("button");
    copyBtn.className = "copy-code-button";
    copyBtn.textContent = "Copy";
    copyBtn.setAttribute('type', 'button');
    copyBtn.setAttribute('aria-label', 'Copy code to clipboard');

    var codeEl = containerEl.querySelector('pre');
    if (!codeEl) {
      return;
    }

    containerEl.style.position = 'relative';
    containerEl.insertBefore(copyBtn, codeEl);

    copyBtn.addEventListener('click', function() {
      try {
        var codeText = codeEl.textContent;
        
        // Use modern clipboard API if available
        if (navigator.clipboard && window.isSecureContext) {
          navigator.clipboard.writeText(codeText).then(function() {
            flashCopyMessage(copyBtn, "Copied!");
          }).catch(function(err) {
            console.error('Failed to copy: ', err);
            flashCopyMessage(copyBtn, "Failed!");
          });
        } else {
          // Fallback for older browsers
          var selection = selectText(codeEl);
          document.execCommand('copy');
          selection.removeAllRanges();
          flashCopyMessage(copyBtn, "Copied!");
        }
      } catch (err) {
        console.error('Failed to copy: ', err);
        flashCopyMessage(copyBtn, "Failed!");
      }
    });
  }

  // Add copy button to code blocks when DOM is ready
  function initCopyButtons() {
    // Jekyll uses .highlight class for code blocks
    var highlightBlocks = document.querySelectorAll('.highlight');
    highlightBlocks.forEach(function(block) {
      // Skip if already has a copy button (prevent duplicates)
      if (block.querySelector('.copy-code-button')) {
        return;
      }
      addCopyButton(block);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initCopyButtons);
  } else {
    initCopyButtons();
  }
})();
