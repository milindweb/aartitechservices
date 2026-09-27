/* ==========================================================================
   Aarti Tech Services — screenshot lightbox
   Click any image inside a .screenshot-grid to view it full size.
   Native <dialog> modal: close via button, backdrop click or Escape.
   Progressive enhancement — the grid still works without JavaScript.
   ========================================================================== */
(function () {
    'use strict';

    var grids = document.querySelectorAll('.screenshot-grid');
    if (!grids.length) {
        return;
    }

    var dialog = document.createElement('dialog');
    dialog.className = 'shot-lightbox';
    dialog.setAttribute('aria-label', 'Screenshot preview');

    var closeBtn = document.createElement('button');
    closeBtn.type = 'button';
    closeBtn.className = 'shot-lightbox-close';
    closeBtn.setAttribute('aria-label', 'Close');
    closeBtn.textContent = '\u00D7';

    var full = document.createElement('img');
    full.alt = '';

    dialog.appendChild(closeBtn);
    dialog.appendChild(full);
    document.body.appendChild(dialog);

    var opener = null;

    function open(img) {
        opener = img;
        full.src = img.currentSrc || img.src;
        full.alt = img.alt || '';

        if (typeof dialog.showModal === 'function') {
            dialog.showModal();
        } else {
            window.open(full.src, '_blank', 'noopener');
            opener = null;
        }
    }

    function close() {
        if (typeof dialog.close === 'function') {
            dialog.close();
        }
    }

    Array.prototype.forEach.call(grids, function (grid) {
        grid.addEventListener('click', function (event) {
            var img = event.target.closest('img');
            if (img) {
                event.preventDefault();
                open(img);
            }
        });
    });

    closeBtn.addEventListener('click', close);

    // Click on the dimmed backdrop (outside the image) closes the dialog.
    dialog.addEventListener('click', function (event) {
        if (event.target === dialog) {
            close();
        }
    });

    // Escape key.
    dialog.addEventListener('cancel', function (event) {
        event.preventDefault();
        close();
    });

    dialog.addEventListener('close', function () {
        full.removeAttribute('src');
        if (opener) {
            opener.focus();
            opener = null;
        }
    });
})();
