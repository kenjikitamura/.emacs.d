
; ロードパス
;(add-to-list 'load-path "/Users/kitamura/Dropbox/storage/emacs/site-lisp")

; 日本語環境
(set-language-environment 'Japanese)

;デフォルト文字コード
(defvar is-mac (or (eq window-system 'mac) (featurep 'ns)))

(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8-unix)
(cond
 (is-mac
  (require 'ucs-normalize)
  (setq file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs)
  )
 (t
  (setq file-name-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8)
  )
 )

(global-set-key "\C-h" 'delete-backward-char)

; Macで濁点が一つの文字にならない設定
(if (equal system-type 'darwin)
    (if (>= emacs-major-version 23)
        (set-file-name-coding-system 'utf-8-nfd)
      (progn
        (require 'utf-8m)
        (set-file-name-coding-system 'utf-8m)))
  (setq file-name-coding-system 'utf-8-unix))

; ファイルを開く際に一つのWindowを使う for Mac
(setq ns-pop-up-frames nil)
(define-key global-map [ns-drag-file] 'ns-find-file)

; バッファー自動再読み込み
(global-auto-revert-mode 1)

; ファイル候補大文字小文字無視
(setq completion-ignore-case t)

; 同じファイル名で複数開いた場合にわかるように
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

; カレント行ハイライト
;(defface hlline-face
;  '((((class color)
;      (background dark))
;     (:background "dark slate gray"))
;    (((class color)
;      (background light))
;     (:background  "#A8FBA8"))
;    (t
;     ()))
;  "*Face used by hl-line.")
;(setq hl-line-face 'hlline-face)
;(global-hl-line-mode)


; package for 24.3
(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

; anything
(require 'anything)
(require 'anything-config)
(add-to-list 'anything-sources 'anything-c-source-emacs-commands)

(define-key global-map (kbd "C-o") 'anything)
(define-key global-map (kbd "C-;") 'anything)
(define-key global-map (kbd "\C-x\C-b") 'electric-buffer-list)
(define-key global-map (kbd "C-u") 'other-window)
;(define-key global-map (kbd "C-U") 'other-window-backword)

;; -----------------------------------------------
;; Carbon Emacs
;;

;; Optionキーをメタキーとして使う
(setq mac-option-modifier 'meta)



;; Cocoa emacs では、fontの設定を行う
(when (eq window-system 'ns)
  (create-fontset-from-ascii-font "Menlo-15:weight=normal:slant=normal" nil "menlokakugo")
  (set-fontset-font "fontset-menlokakugo" 'unicode (font-spec :family "Hiragino Kaku Gothic ProN" ) nil 'append)
  (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
  (setq face-font-rescale-alist '((".*Hiragino.*" . 1.3) (".*Menlo.*" . 1.1)))
)

(set-face-background 'region "SkyBlue")
(set-face-foreground 'region "black")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-key global-map "\C-c\C-d" 'insert-time-and-date-notepad)

(define-key global-map "\M-n" (lambda () (interactive) (scroll-up 1)))
(define-key global-map "\M-p" (lambda () (interactive) (scroll-down 1)))

(define-key global-map "\M-g" 'fill-region)

(define-key global-map "\M-o" 'delete-blank-lines) ; default C-x C-o
(define-key global-map "\C-x\C-o" (lambda () (interactive) (other-window -1)))
(define-key global-map "\C-x'" 'compile) ; default = expand abbrev

(define-key help-map "a" 'apropos)

;;; org-mode
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-cycle-include-plain-lists t) ; plain list もTABで縮約する
(setq org-log-done t) ; done のときにタイムスタンプを挿入する
;(define-key org-mode-map (quote [67108910]) 'org-goto) ; C-. を C-c C-j 替わりに。
(define-key org-mode-map (quote [end]) 'org-goto) ; ENDを C-c C-j 替わりに。

(global-set-key "\M-n" 'linum-mode)

;
(require 'auto-save-buffers)
(run-with-idle-timer 5 t 'auto-save-buffers) 


(require 'server)
(unless (server-running-p)
  (server-start))

;; Rinari : Ruby on Rails Minor Mode for Emacs
;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)
;; Rinari
(add-to-list 'load-path "~/path/to/your/elisp/rinari")
(require 'rinari)


(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/Users/kitamura/Dropbox/storage/emacs/site-lisp/auto-complete-1.3.1/ac-dict")
(ac-config-default)

;; Twitter
(require 'twittering-mode)
;; 起動時パスワード認証 *要 gpgコマンド
(setq twittering-use-master-password t)
;; パスワード暗号ファイル保存先変更 (デフォはホームディレクトリ)
;(setq twittering-private-info-file "~/.emacs.d/twittering-mode.gpg")
;; 表示する書式 区切り線いれたら見やすい
(setq twittering-status-format "%i @%s %S %p: \n %T %R\n")

;; アイコンを表示する
(setq twittering-icon-mode t)
;; アイコンサイズを変更する *48以外を希望する場合 要 imagemagickコマンド
(setq twittering-convert-fix-size 40)
;; 更新の頻度（秒）
(setq twittering-timer-interval 40)
;; ツイート取得数
(setq twittering-number-of-tweets-on-retrieval 50)
;; o で次のURLをブラウザでオープン
(add-hook 'twittering-mode-hook
          (lambda ()
            (local-set-key (kbd "o")
                           (lambda ()
                             (interactive)
                             (twittering-goto-next-uri)
                             (execute-kbd-macro (kbd "C-m"))
                             ))))

;; コマンドにパスを通す
(add-to-list 'exec-path "/usr/local/bin")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs終了時に確認メッセージを出す。
;; 誤って終了してしまわないようにするため
;; ref: http://blog.livedoor.jp/techblog/archives/64599359.html
(defadvice save-buffers-kill-emacs
  (before safe-save-buffers-kill-emacs activate)
  "safe-save-buffers-kill-emacs"
  (unless (y-or-n-p "Really exit emacs? ")
    (keyboard-quit)))


(require 'scala-mode)
(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
(add-hook 'scala-mode-hook
  (function
    (lambda ()
      (setq scala-mode-indent:step 4)
      (scala-mode-lib:define-keys scala-mode-map
                                  ([(shift tab)]   'scala-undent-line)
                                  ([(control tab)] nil))
      (local-set-key [(return)] 'newline-and-indent))))
(add-hook 'scala-mode-hook 'jaspace-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (wheatgrass)))
 '(custom-safe-themes (quote ("fe6330ecf168de137bb5eddbf9faae1ec123787b5489c14fa5fa627de1d9f82b" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
