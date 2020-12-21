(require 'iso-transl)
(set-keyboard-coding-system 'utf-8)


; list the repositories containing them
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

; activate all the packages (in particular autoloads)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blacken-skip-string-normalization t)
 '(css-indent-offset 2)
 '(flycheck-rubocop-lint-only t)
 '(js-indent-level 2)
 '(kotlin-tab-width 4)
 '(neo-confirm-change-root (quote off-p))
 '(neo-show-hidden-files t)
 '(package-selected-packages
   (quote
    (tide blacken flycheck virtualenvwrapper dockerfile-mode haskell-mode multi-term scala-mode company-lsp lsp-mode jedi typescript-mode yaml-mode company eglot flycheck-kotlin terraform-mode rjsx-mode jsx-mode js-auto-beautify ## kotlin-mode stylus-mode web-mode prettier-js robe neotree enh-ruby-mode auto-complete smartparens projectile monokai-theme better-defaults)))
 '(save-interprogram-paste-before-kill t)
 '(save-place-mode t)
 '(show-trailing-whitespace nil)
 '(terraform-indent-level 2)
 '(typescript-indent-level 2)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-tests-directory "~/tests/"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(exec-path-from-shell-initialize)

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'ruby-mode)

(defalias 'yes-or-no-p 'y-or-n-p)

;; Navigate between windows using Shift-left, shift-up, shift-right
(windmove-default-keybindings)

;; Enable copy and pasting from clipboard
(setq x-select-enable-clipboard t)

;; load monokai theme
(load-theme 'monokai t)

;; Show line numbers
(global-linum-mode)

;; Columns numbers
(setq column-number-mode t)

;; Projectile Mode
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; better defaults
(require 'better-defaults)

;; Function to copy file name to clipboard
(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                   (seq-subseq (buffer-file-name) (length (projectile-project-root))))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(global-set-key (kbd "C-x C-j") 'copy-file-name-to-clipboard)

;; Smart Parens configuration
(require 'smartparens-config)
(require 'smartparens-ruby)
(smartparens-global-mode)
(show-smartparens-global-mode t)
(sp-with-modes '(rhtml-mode)
  (sp-local-pair "<" ">")
  (sp-local-pair "<%" "%>"))

;; Remove trailing whitespaces
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

;; ruby enh mode
(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

(require 'auto-complete-config)
(add-to-list 'ac-modes 'enh-ruby-mode)

(add-hook 'ruby-mode-hook 'robe-mode)
(add-hook 'robe-mode-hook 'ac-robe-setup)

;; neotree
(add-to-list 'load-path ".emacs.d/neotree-20180616.1603/neotree.el")
(require 'neotree)

;; neotree key
(global-set-key (kbd "C-x C-p") 'neotree-find)

;; does not add utf-8 on file
(setq ruby-insert-encoding-magic-comment nil)
(setq enh-ruby-add-encoding-comment-on-save nil)

;; disable message log
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; make backup to a designated dir, mirroring the full path

(defun my-backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* (
        (backupRootDir "~/.emacs.d/emacs-backup/")
        (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path, for example, “C:”
        (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") ))
        )
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath
  )
)

(setq make-backup-file-name-function 'my-backup-file-name)
(setq auto-save-file nil)
(setq create-lockfiles nil)

(require 'terraform-mode)
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

(setq auto-save-file-name-transforms
  `((".*" "~/.emacs.d/emacs-save/" t)))

(setq explicit-shell-file-name "/bin/sh")

(setq tab-width 2)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx$" . web-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

(autoload 'typescript-mode "typescript-mode" "Major mode for tsx files" t)
(add-to-list 'auto-mode-alist '("\\.ts$" . typescript-mode))

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; enable prettier-js on javascript mode
(require 'prettier-js)
(add-hook 'js-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'typescript-mode-hook 'prettier-js-mode)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(add-hook 'typescript-mode-hook #'setup-tide-mode)
(add-hook 'web-mode-hook #'setup-tide-mode)

;; multi-term configuration

(require 'multi-term)
(setq multi-term-program "/bin/zsh")

;; spotify

(add-to-list 'load-path "~/spotify.el")
(require 'spotify)

;; Settings
(setq spotify-oauth2-client-secret "ae6dfbc75a0447d39596491c208bd359")
(setq spotify-oauth2-client-id "03235af39f8d41189ce886a7fa126b1b")
(define-key spotify-mode-map (kbd "C-c .") 'spotify-command-map)

(setq spotify-transport 'connect)

;; enable flycheck in python buffers
(defun flycheck-python-setup ()
  (flycheck-mode))
(add-hook 'python-mode-hook #'flycheck-python-setup)

;; autoload virtualenv at current project
(setq projectile-switch-project-action
      '(lambda ()
         (venv-projectile-auto-workon)
         (projectile-find-file)))

(setq-default flycheck-disabled-checkers '(python-flake8))

;; enable python formatter black
(add-hook 'python-mode-hook 'blacken-mode)

;; ;; auto import missing dependencies
;; (define-key python-mode-map (kbd "C-c a") #'pyimport-insert-missing)
