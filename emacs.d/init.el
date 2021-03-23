(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
            (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
    'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                        ("melpa" . "https://melpa.org/packages/")
                        ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
        :ensure t
        :init
        ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
       (leaf hydra :ensure t)
        (leaf el-get :ensure t)
        (leaf blackout :ensure t)

       :config
        ;; initialize leaf-keywords.el
        (leaf-keywords-init)))

;; leaf.elの設定
(leaf cus-edit
      :doc "tools for customizing Emacs and Lisp packages"
      :tag "builtin" "faces" "help"
      :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))
(leaf cus-start
      :doc "define customization properties of builtins"
      :tag "builtin" "internal"
      :preface
      (defun c/redraw-frame nil
        (interactive)
        (redraw-frame))

      :bind (("M-ESC ESC" . c/redraw-frame))
      :custom '((user-full-name . "Kota Kato")
                (user-mail-address . "peony.btn@gmail.com")
                (user-login-name . "katokota")
                (create-lockfiles . nil)
                (debug-on-error . t)
                (init-file-debug . t)
                (frame-resize-pixelwise . t)
                (enable-recursive-minibuffers . t)
                (history-length . 1000)
                (history-delete-duplicates . t)
                (scroll-preserve-screen-position . t)
                (scroll-conservatively . 100)
                (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
                (ring-bell-function . 'ignore)
                (text-quoting-style . 'straight)
                (truncate-lines . t)
                ;; (use-dialog-box . nil)
                ;; (use-file-dialog . nil)
                ;; (menu-bar-mode . t)
                ;; (tool-bar-mode . nil)
                (scroll-bar-mode . nil)
                (indent-tabs-mode . nil))
      :config
      (defalias 'yes-or-no-p 'y-or-n-p)
      (keyboard-translate ?\C-h ?\C-?))

;; 自動でファイルを読み直します
(leaf autorevert
      :doc "revert buffers when files on disk change"
     :tag "builtin"
      :custom ((auto-revert-interval . 1))
      :global-minor-mode global-auto-revert-mode)

;; C系のファイルに関するモード
(leaf cc-mode
      :doc "major mode for editing C and similar languages"
      :tag "builtin"
      :defvar (c-basic-offset)
      :bind (c-mode-base-map
              ("C-c c" . compile))
      :mode-hook
      (c-mode-hook . ((c-set-style "bsd")
                      (setq c-basic-offset 4)))
      (c++-mode-hook . ((c-set-style "bsd")
                        (setq c-basic-offset 4))))

;; regionを上書きして挿入するマイナーモード
(leaf delsel
      :doc "delete selection if you insert"
      :tag "builtin"
      :global-minor-mode delete-selection-mode)

;; 対応する括弧を強調するマイナーモード
(leaf paren
      :doc "highlight matching paren"
      :tag "builtin"
      :custom ((show-paren-delay . 0.1))
      :global-minor-mode show-paren-mode)

;; kill-ringの数を制御したり、kill-lineの挙動を変更したりする
(leaf files
      :doc "file input and output commands for Emacs"
      :tag "builtin"
      :custom `((auto-save-timeout . 15)
                (auto-save-interval . 60)
                (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
                (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                            (,tramp-file-name-regexp . nil)))
                (version-control . t)
                (delete-old-versions . t)))

(leaf ivy
      :doc "Incremental Vertical completYon"
      :req "emacs-24.5"
      :tag "matching" "emacs>=24.5"
      :url "https://github.com/abo-abo/swiper"
      :emacs>= 24.5
      :ensure t
      :blackout t
      :leaf-defer nil
      :custom ((ivy-initial-inputs-alist . nil)
               (ivy-use-selectable-prompt . t))
      :global-minor-mode t
      :config
      (leaf swiper
            :doc "Isearch with an overview. Oh, man!"
            :req "emacs-24.5" "ivy-0.13.0"
            :tag "matching" "emacs>=24.5"
            :url "https://github.com/abo-abo/swiper"
            :emacs>= 24.5
            :ensure t
            :bind (("C-s" . swiper)))

      (leaf counsel
            :doc "Various completion functions using Ivy"
            :req "emacs-24.5" "swiper-0.13.0"
            :tag "tools" "matching" "convenience" "emacs>=24.5"
            :url "https://github.com/abo-abo/swiper"
            :emacs>= 24.5
            :ensure t
            :blackout t
            :bind (("C-S-s" . counsel-imenu)
                   ("C-x C-r" . counsel-recentf))
            :custom `((counsel-yank-pop-separator . "\n----------\n")
                      (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
            :global-minor-mode t))

(leaf prescient
      :doc "Better sorting and filtering"
      :req "emacs-25.1"
      :tag "extensions" "emacs>=25.1"
      :url "https://github.com/raxod502/prescient.el"
      :emacs>= 25.1
      :ensure t
      :custom ((prescient-aggressive-file-save . t))
      :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
      :doc "prescient.el + Ivy"
      :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
      :tag "extensions" "emacs>=25.1"
      :url "https://github.com/raxod502/prescient.el"
      :emacs>= 25.1
      :ensure t
      :after prescient ivy
      :custom ((ivy-prescient-retain-classic-highlighting . t))
      :global-minor-mode t)

(leaf atom-one-dark-theme
      :config (load-theme 'atom-one-dark t))

(leaf nyan-mode
  :config (nyan-mode)
          (nyan-start-animation))

(leaf lsp-mode
  :custom ((lsp-clients-clangd-excutable '/usr/local/opt/llvm/bin//clangd)))

(leaf lsp-ui)

(leaf company-lsp)

(leaf neotree
  :ensure t)
  
(provide 'init)

;; Splashに画像を表示
(setq fancy-splash-image (expand-file-name "~/.emacs.d/images/splash.png"))
;; Backup fileを作らない
(setq make-backup-files nil)
(setq auto-save-default nil)
;; C-hをDeleteにする
(define-key key-translation-map [?\C-h] [?\C-?])
;; C-wをDeleteにする
(defun backward-kill-word-or-kill-region ()
  (interactive)
  (if (or (not transient-mark-mode) (region-active-p))
    (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))
(global-set-key "\C-w" 'backward-kill-word-or-kill-region)
;; default directory
(setq default-directory "~/")
(setq command-line-default-directory "~/")
;; 起動時のサイズ,表示位置,フォントを指定
(setq initial-frame-alist
      (append (list
                '(width . 160)
                '(height . 55)
                '(top . 0)
                '(left . 0)
                '(font . "Cica-13")
                )
              initial-frame-alist))

