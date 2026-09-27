/* ==========================================================================
   Aarti Tech Services — screenshot gallery carousel
   Turns each [data-gallery] .screenshot-grid into a one-image-at-a-time
   horizontal carousel with prev/next buttons, a "current / total" counter
   and keyboard (arrow / Home / End) support.
   Native scroll-snap handles swipe and trackpad scrolling; this script only
   adds the controls, counter and arrow buttons.
   Progressive enhancement — without JavaScript the grid still scrolls.
   ========================================================================== */
(function () {
    'use strict';

    var galleries = document.querySelectorAll('[data-gallery]');
    if (!galleries.length) {
        return;
    }

    function reducedMotion() {
        return window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    }

    Array.prototype.forEach.call(galleries, function (root) {
        var grid = root.querySelector('.screenshot-grid');
        if (!grid) {
            return;
        }

        var imgs = grid.querySelectorAll('img');
        var total = imgs.length;
        var prev = root.querySelector('.gallery-nav.prev');
        var next = root.querySelector('.gallery-nav.next');
        var counter = root.querySelector('.gallery-count');

        if (total < 2) {
            if (prev) { prev.style.display = 'none'; }
            if (next) { next.style.display = 'none'; }
            if (counter) { counter.style.display = 'none'; }
            return;
        }

        var current = 0;

        function positionOf(i) {
            return imgs[i].offsetLeft - imgs[0].offsetLeft;
        }

        function currentIndex() {
            var probe = grid.scrollLeft + grid.clientWidth / 2;
            var best = 0;
            var bestDist = Infinity;
            for (var i = 0; i < total; i++) {
                var dist = Math.abs(positionOf(i) + imgs[i].offsetWidth / 2 - probe);
                if (dist < bestDist) {
                    bestDist = dist;
                    best = i;
                }
            }
            return best;
        }

        function sync() {
            if (counter) {
                counter.textContent = (current + 1) + ' / ' + total;
            }
            if (prev) {
                prev.disabled = current <= 0;
            }
            if (next) {
                next.disabled = current >= total - 1;
            }
        }

        function goTo(i) {
            if (i < 0) { i = 0; }
            if (i > total - 1) { i = total - 1; }
            var left = positionOf(i) - (grid.clientWidth - imgs[i].offsetWidth) / 2;
            if (typeof grid.scrollTo === 'function') {
                grid.scrollTo({ left: left, behavior: reducedMotion() ? 'auto' : 'smooth' });
            } else {
                grid.scrollLeft = left;
            }
            current = i;
            sync();
        }

        var ticking = false;

        function onScroll() {
            if (ticking) {
                return;
            }
            ticking = true;
            window.requestAnimationFrame(function () {
                ticking = false;
                var i = currentIndex();
                if (i !== current) {
                    current = i;
                    sync();
                }
            });
        }

        if (prev) {
            prev.addEventListener('click', function () { goTo(current - 1); });
        }
        if (next) {
            next.addEventListener('click', function () { goTo(current + 1); });
        }

        grid.addEventListener('scroll', onScroll, { passive: true });

        grid.addEventListener('keydown', function (event) {
            if (event.key === 'ArrowLeft') {
                event.preventDefault();
                goTo(current - 1);
            } else if (event.key === 'ArrowRight') {
                event.preventDefault();
                goTo(current + 1);
            } else if (event.key === 'Home') {
                event.preventDefault();
                goTo(0);
            } else if (event.key === 'End') {
                event.preventDefault();
                goTo(total - 1);
            }
        });

        window.addEventListener('resize', function () {
            current = currentIndex();
            sync();
        });

        if (document.readyState === 'complete') {
            sync();
        } else {
            window.addEventListener('load', sync);
        }
    });
})();
