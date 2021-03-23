(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-revert-interval 1)
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/backup/" t)))
 '(auto-save-interval 60)
 '(auto-save-timeout 15)
 '(backup-directory-alist '((".*" . "~/.emacs.d/backup") ("\\`/[^/:]+:[^/:]*:")))
 '(counsel-find-file-ignore-regexp "\\(?:\\.\\(?:\\.?/\\)\\)")
 '(counsel-yank-pop-separator "
----------
")
 '(create-lockfiles nil)
 '(custom-file "~/.emacs.d/custom.el")
 '(debug-on-error t)
 '(delete-old-versions t)
 '(enable-recursive-minibuffers t)
 '(frame-resize-pixelwise t)
 '(history-delete-duplicates t)
 '(history-length 1000)
 '(indent-tabs-mode nil)
 '(init-file-debug t t)
 '(ivy-initial-inputs-alist nil)
 '(ivy-prescient-retain-classic-highlighting t)
 '(ivy-use-selectable-prompt t)
 '(mouse-wheel-scroll-amount '(1 ((control) . 5)))
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("org" . "https://orgmode.org/elpa/")))
 '(package-selected-packages
   '(neotree nyan-mode leaf-tree leaf-convert ivy-prescient hydra el-get doom-themes counsel blackout atom-one-dark-theme))
 '(prescient-aggressive-file-save t)
 '(ring-bell-function 'ignore)
 '(scroll-bar-mode nil)
 '(scroll-conservatively 100)
 '(scroll-preserve-screen-position t)
 '(show-paren-delay 0.1)
 '(text-quoting-style 'straight)
 '(truncate-lines t)
 '(user-full-name "Kota Kato")
 '(user-login-name "katokota" t)
 '(user-mail-address "peony.btn@gmail.com")
 '(version-control t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
