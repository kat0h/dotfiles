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
(setq custom-file (locate-user-emacs-file "custom.el"))
(setq user-full-name "Kota Kato")
(setq user-mail-address "peony.btn@gmail.com")
(setq user-login-name "katokota")
(setq create-lockfiles nil)
(setq debug-on-error t)
(setq init-file-debug t)
(setq frame-resize-pixelwise t)
(setq enable-recursive-minibuffers t)
(setq history-length 1000)
(setq history-delete-duplicates t)
(setq scroll-preserve-screen-position t)
(setq scroll-conservatively 100)
(setq mouse-wheel-scroll-amount '(1 ((control) . 5)))
(setq ring-bell-function 'ignore)
(setq text-quoting-style 'straight)
(setq truncate-lines t)
(setq fancy-splash-image (expand-file-name "~/.emacs.d/images/splash.png")) ; Splashに画像を表示
(setq make-backup-files nil) ; Backup fileを作らない
(setq auto-save-default nil)
(setq default-directory "~/") ; default directory
(setq command-line-default-directory "~/")

(define-key key-translation-map [?\C-h] [?\C-?]) ; C-hをDeleteにする
(defalias 'yes-or-no-p 'y-or-n-p)

;; C-wをいい感じにする
(defun backward-kill-word-or-kill-region ()
  (interactive)
  (if (or (not transient-mark-mode) (region-active-p))
    (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))
(global-set-key "\C-w" 'backward-kill-word-or-kill-region)

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

;; 自動でファイルを読み直します
(leaf autorevert
      :ensure t
      :doc "revert buffers when files on disk change"
      :tag "builtin"
      :custom ((auto-revert-interval . 1))
      :global-minor-mode global-auto-revert-mode)

;; C系のファイルに関するモード
(leaf cc-mode
      :doc "major mode for editing C and similar languages"
      :tag "builtin"
      :ensure t
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
      :ensure t
      :doc "delete selection if you insert"
      :tag "builtin"
      :global-minor-mode delete-selection-mode)

;; 対応する括弧を強調するマイナーモード
(leaf paren
      :ensure t
      :doc "highlight matching paren"
      :tag "builtin"
      :custom ((show-paren-delay . 0.1))
      :global-minor-mode show-paren-mode)

(leaf atom-one-dark-theme
      :ensure t
      :config (load-theme 'atom-one-dark t))

(leaf nyan-mode
      :ensure t
      :config (nyan-mode)
      (nyan-start-animation))

(leaf neotree
      :ensure t)

(leaf leaf-convert
  :ensure t)

(provide 'init)
