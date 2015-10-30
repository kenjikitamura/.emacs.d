; ロードパス
(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/lisp/rinari")
(add-to-list 'load-path "~/.emacs.d/lisp/scala-mode2")
(add-to-list 'load-path "~/.emacs.d/lisp/twittering-mode")
(add-to-list 'load-path "~/.emacs.d/lisp/scala")
(add-to-list 'load-path "~/.emacs.d/lisp/yasnippet")

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
  (mac-auto-ascii-mode 1)
  )
 (t
  (setq file-name-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8)
  )
 )

(global-set-key "\C-h" 'delete-backward-char)

; Macで濁点が一つの文字にならない設定
(if (equal system-type 'darwin)
    (if (= emacs-major-version 23)
        (set-file-name-coding-system 'utf-8-nfd)
      (if (< emacs-major-version 23)
          (progn
            (require 'utf-8m)
            (set-file-name-coding-system 'utf-8m))))
  (setq file-name-coding-system 'utf-8-unix))

; ファイルを開く際に一つのWindowを使う for Mac
(setq ns-pop-up-frames nil)
(define-key global-map [ns-drag-file] 'ns-find-file)

; バッファー自動再読み込み
(global-auto-revert-mode 1)

; ファイル候補大文字小文字無視
(setq completion-ignore-case t)

; キーバインド
(global-set-key (kbd "C-%") 'replace-string)

; 同じファイル名で複数開いた場合にわかるように
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

; カレント行ハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "#202020"))
    (((class color)
      (background light))
     (:background  "#A8FBA8"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)

;; ツールバーを非表示
(tool-bar-mode -1)
;; メニューバーを非表示
(menu-bar-mode -1)


; package for 24.3
(if (>= emacs-major-version 23)
    (progn
      (require 'package)
      (add-to-list 'package-archives 
                   '("marmalade" .
                     "http://marmalade-repo.org/packages/"))
      (package-initialize))
  )


; anything
;(require 'anything)
;(require 'anything-config)
;(global-set-key (kbd "C-x b") 'anything-for-files)
;(global-set-key (kbd "M-y") 'anything-show-kill-ring)

;(define-key global-map (kbd "C-o") 'anything)
;(define-key global-map (kbd "C-;") 'anything)
(define-key global-map (kbd "\C-x\C-b") 'electric-buffer-list)
;(define-key global-map (kbd "C-u") 'other-window)
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


; server
(require 'server)
(unless (server-running-p)
  (server-start))

;; Rinari : Ruby on Rails Minor Mode for Emacs
;; Interactively Do Things (highly recommended, but not strictly required)
;(require 'ido)
;(ido-mode t)
;; Rinari
(add-to-list 'load-path "~/path/to/your/elisp/rinari")
(require 'rinari)


(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/Users/kitamura/Dropbox/storage/emacs/site-lisp/auto-complete-1.3.1/ac-dict")
(add-to-list 'ac-modes 'java-mode)
(ac-config-default)
(require 'auto-complete)
(global-auto-complete-mode t)

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

(require 'scala-mode2)
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

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;-------------------------------------------------------
;; yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        "~/.emacs.d/lisp/yasnippet/snippets"
        ))
(yas-global-mode 1)

(custom-set-variables '(yas-trigger-key "TAB"))

;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)


(setq custom-theme-directory "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'wombat-custom t)
;(load-theme 'wombat t)
;(load-theme 'deeper-blue t)
;(enable-theme 'deeper-blue)

;; バックアップファイルの場所を変更
(setq backup-directory-alist
  (cons (cons ".*" (expand-file-name "~/.emacs.d/backup"))
        backup-directory-alist))


;; 起動時から global-auto-revert-mode を有効にする
(global-auto-revert-mode 1)

;; org-mode
(setq org-agenda-files '("~/Dropbox/work/org"))
(custom-set-variables
  '(org-display-custom-times t)
  '(org-time-stamp-custom-formats (quote ("<%Y年%m月%d日(%a)>" . "<%Y年%m月%d日(%a)%H時%M分>")))
)


;; navi2ch
(add-to-list 'load-path "~/.emacs.d/lisp/navi2ch-1.8.4")
(autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)

;; GTAGS
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\C-t" 'gtags-pop-stack)
         ))

; scheme
(setq scheme-program-name "gosh")
(require 'cmuscheme)

(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(define-key global-map
  "\C-cS" 'scheme-other-window)

;; タブを使わず、スペースを使う
(setq-default tab-width 4 indent-tabs-mode nil)

;; タブ、全角スペース表示
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
(defface my-face-b-1 '((t (:background "dark turquoise"))) nil)
(defface my-face-b-2 '((t (:background "cyan"))) nil)
(defface my-face-b-2 '((t (:background "SeaGreen"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("　" 0 my-face-b-1 append)
     ("\t" 0 my-face-b-2 append)
     ("[ ]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
                              (if font-lock-mode
                                  nil
                                (font-lock-mode t))))


;; minibuf-isearch
(require 'minibuf-isearch)

;; helm
(add-to-list 'load-path "~/.emacs.d/lisp/helm")
(require 'helm-config)
(require 'helm-ag)
(require 'helm-ls-git)

; Helm Descbinds
(require 'helm-descbinds)

; Helm Settings
(progn
  (custom-set-variables
   '(helm-truncate-lines t)
   '(helm-buffer-max-length 40)
   '(helm-delete-minibuffer-contents-from-point t)
   '(helm-ff-skip-boring-files t)
   '(helm-boring-file-regexp-list '("~$" "\\.elc$"))
   '(helm-ls-git-show-abs-or-relative 'relative)
   '(helm-mini-default-sources '(helm-source-buffers-list
                                 helm-source-ls-git
                                 helm-source-recentf
                                 helm-source-buffer-not-found))))


;; prior to emacs24
(helm-descbinds-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-l") 'helm-mini)
(global-set-key (kbd "C-o") 'helm-ls-git-ls)
;(global-set-key (kbd "C-o") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-c b") 'helm-descbinds)
(global-set-key (kbd "C-c o") 'helm-occur)
(global-set-key (kbd "C-c s") 'helm-ag)
(global-set-key (kbd "C-c y") 'helm-show-kill-ring)

; helmのminibufferでC-hを有効にする設定
(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

; goto
(global-set-key "\M-g" 'goto-line)

; 行番号の設定
(custom-set-faces
 '(linum ((t (:inherit (shadow default) :background "Gray40")))))

; Highlight-synbol
; C-x C-hでハイライトON/OFF
(require 'highlight-symbol)
(setq highlight-symbol-colors '("DarkOrange" "DodgerBlue1" "DeepPink1"))
(global-set-key "\C-x\C-h" 'highlight-symbol-at-point)
;(global-set-key [f3] 'highlight-symbol-next)
;(global-set-key [(shift f3)] 'highlight-symbol-prev)
;(global-set-key [(meta f3)] 'highlight-symbol-query-replace) ; ハイライトを置換

;; 適宜keybindの設定
(global-set-key (kbd "<f3>") 'highlight-symbol-at-point)
(global-set-key (kbd "M-<f3>") 'highlight-symbol-remove-all)


;; C-s C-wでカーソル上の単語検索
(defun isearch-forward-with-heading ()
  "Search the word your cursor looking at."
  (interactive)
  (command-execute 'backward-word)
  (command-execute 'isearch-forward))
(global-set-key (kbd "C-s") 'isearch-forward-with-heading)

;; Ctrl+Zで最小化しない
(define-key global-map "\C-z" 'recenter)

;; スクリプトっぽかったら勝手に実行ビットを立てる
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

; 対応する括弧の表示
(show-paren-mode t)

; Enhanced Ruby Mode
(add-to-list 'load-path "~/.emacs.d/lisp/enhanced-ruby-mode") ; must be added after any path containing old ruby-mode
(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

; ruby-electric
(add-to-list 'load-path "~/.emacs.d/lisp/ruby-electric")
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
(setq ruby-electric-expand-delimiters-list nil)

;; ruby-block.el --- highlight matching block
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)


(setq auto-mode-alist
      (append '(
                ("\\.\\(html\\|xhtml\\|shtml\\|tpl\\)\\'" . web-mode)
                ("\\.php\\'" . php-mode)
                )
              auto-mode-alist))

;;==========================================================
;;         web-modeの設定
;;==========================================================
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))
(defun web-mode-hook ()
  "Hooks for Web mode."
  ;; 変更日時の自動修正
  (setq time-stamp-line-limit -200)
  (if (not (memq 'time-stamp write-file-hooks))
      (setq write-file-hooks
            (cons 'time-stamp write-file-hooks)))
  (setq time-stamp-format " %3a %3b %02d %02H:%02M:%02S %:y %Z")
  (setq time-stamp-end "$")
  ;; web-modeの設定
  (setq web-mode-markup-indent-offset 2) ;; html indent
  (setq web-mode-css-indent-offset 2)    ;; css indent
  (setq web-mode-code-indent-offset 2)   ;; script indent(js,php,etc..)
  ;; htmlの内容をインデント
  ;; TEXTAREA等の中身をインデントすると副作用が起こったりするので
  ;; デフォルトではインデントしない
  ;;(setq web-mode-indent-style 2)
  ;; コメントのスタイル
  ;;   1:htmlのコメントスタイル(default)
  ;;   2:テンプレートエンジンのコメントスタイル
  ;;      (Ex. {# django comment #},{* smarty comment *},{{-- blade comment --}})
  (setq web-mode-comment-style 2)
  ;; 終了タグの自動補完をしない
  ;;(setq web-mode-disable-auto-pairing t)
  ;; color:#ff0000;等とした場合に指定した色をbgに表示しない
  ;;(setq web-mode-disable-css-colorization t)
  ;;css,js,php,etc..の範囲をbg色で表示
  ;; (setq web-mode-enable-block-faces t)
  ;; (custom-set-faces
  ;;  '(web-mode-server-face
  ;;    ((t (:background "grey"))))                  ; template Blockの背景色
  ;;  '(web-mode-css-face
  ;;    ((t (:background "grey18"))))                ; CSS Blockの背景色
  ;;  '(web-mode-javascript-face
  ;;    ((t (:background "grey36"))))                ; javascript Blockの背景色
  ;;  )
  ;;(setq web-mode-enable-heredoc-fontification t)
)
(add-hook 'web-mode-hook  'web-mode-hook)
;; 色の設定
(custom-set-faces
 '(web-mode-doctype-face
   ((t (:foreground "#82AE46"))))                          ; doctype
 '(web-mode-html-tag-face
   ((t (:foreground "#E6B422" :weight bold))))             ; 要素名
 '(web-mode-html-attr-name-face
   ((t (:foreground "#C97586"))))                          ; 属性名など
 '(web-mode-html-attr-value-face
   ((t (:foreground "#82AE46"))))                          ; 属性値
 '(web-mode-comment-face
   ((t (:foreground "#D9333F"))))                          ; コメント
 '(web-mode-server-comment-face
   ((t (:foreground "#D9333F"))))                          ; コメント
 '(web-mode-css-rule-face
   ((t (:foreground "#A0D8EF"))))                          ; cssのタグ
 '(web-mode-css-pseudo-class-face
   ((t (:foreground "#FF7F00"))))                          ; css 疑似クラス
 '(web-mode-css-at-rule-face
   ((t (:foreground "#FF7F00"))))                          ; cssのタグ
)

; direx
(require 'direx)
;(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

; popwin
(require 'popwin)
(popwin-mode 1)

; direxをpopwin
(push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)

; helmをpopwin
(when (require 'popwin)
  (setq helm-samewindow nil)
  (setq display-buffer-function 'popwin:display-buffer)
  (setq popwin:special-display-config '(("*compilatoin*" :noselect t)
                                        ("helm" :regexp t :height 0.4)
                                        )))

; バッファ名が同じ場合に、ディレクトリ名を表示する
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

; 動的略語補完
(global-set-key (kbd "C-t") 'dabbrev-expand)

; redo
(require 'redo+)
(global-set-key (kbd "C-/") 'undo)
(global-set-key (kbd "M-/") 'redo)
(setq undo-no-redo t)
(setq undo-limit 60000)
(setq undo-strong-limit 900000)

; goto-chg.el 最後に編集した場所へジャンプする
(require 'goto-chg)
(define-key global-map (kbd "C-x C-l") 'goto-last-change)
(define-key global-map (kbd "C-x C-S-l") 'goto-last-change-reverse)


; quickrun
(require 'quickrun)
(push '("*quickrun*") popwin:special-display-config)
(global-set-key (kbd "C-c r") 'quickrun)

; 最近使ったファイル
; M-x recentf-open-filesで使える
(require 'recentf)
(recentf-mode 1)
(global-set-key (kbd "C-x C-y") 'recentf-open-files)
; 保存する最近使ったファイルのファイル数を無限に
(setq recentf-max-saved-items nil)

; 括弧の対応に色づけ
;(require 'rainbow-delimiters)
;(global-rainbow-delimiters-mode)
;(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

; powerline
;; powerline.el
(defun arrow-right-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
\". c %s\",
\"  c %s\",
\".           \",
\"..          \",
\"...         \",
\"....        \",
\".....       \",
\"......      \",
\".......     \",
\"........    \",
\".........   \",
\".........   \",
\"........    \",
\".......     \",
\"......      \",
\".....       \",
\"....        \",
\"...         \",
\"..          \",
\".           \"};"  color1 color2))

(defun arrow-left-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
\". c %s\",
\"  c %s\",
\"           .\",
\"          ..\",
\"         ...\",
\"        ....\",
\"       .....\",
\"      ......\",
\"     .......\",
\"    ........\",
\"   .........\",
\"   .........\",
\"    ........\",
\"     .......\",
\"      ......\",
\"       .....\",
\"        ....\",
\"         ...\",
\"          ..\",
\"           .\"};"  color2 color1))


(defconst color1 "#384048")
(defconst color3 "#182028")
(defconst color2 "#283038")
(defconst color4 "#CDC0B0")

(defvar arrow-right-1 (create-image (arrow-right-xpm color1 color2) 'xpm t :ascent 'center))
(defvar arrow-right-2 (create-image (arrow-right-xpm color2 "None") 'xpm t :ascent 'center))
(defvar arrow-left-1  (create-image (arrow-left-xpm color2 color1) 'xpm t :ascent 'center))
(defvar arrow-left-2  (create-image (arrow-left-xpm "None" color2) 'xpm t :ascent 'center))

(setq-default mode-line-format
 (list  '(:eval (concat (propertize " %b " 'face 'mode-line-color-1)
                        (propertize " " 'display arrow-right-1)))
        '(:eval (concat (propertize " %m " 'face 'mode-line-color-2)
                        (propertize " " 'display arrow-right-2)))

        ;; Justify right by filling with spaces to right fringe - 16
        ;; (16 should be computed rahter than hardcoded)
        '(:eval (propertize " " 'display '((space :align-to (- right-fringe 17)))))

        '(:eval (concat (propertize " " 'display arrow-left-2)
                        (propertize " %p " 'face 'mode-line-color-2)))
        '(:eval (concat (propertize " " 'display arrow-left-1)
                        (propertize "%4l:%2c  " 'face 'mode-line-color-1)))
)) 

(make-face 'mode-line-color-1)
(set-face-attribute 'mode-line-color-1 nil
                    :foreground "#fff"
                    :background color1)

(make-face 'mode-line-color-2)
(set-face-attribute 'mode-line-color-2 nil
                    :foreground "#fff"
                    :background color2)

(set-face-attribute 'mode-line nil
                    :foreground "#fff"
                    :background color3
                    :box nil)
(set-face-attribute 'mode-line-inactive nil
                    :foreground "#fff"
                    :background color4)

;; Emacs24用Melpa設定
(package-initialize)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)


; フレーム移動
(global-set-key (kbd "C-c C-o") 'other-frame)
(define-key org-mode-map (kbd "C-c C-o") nil) ; org-modeのキーバインドを削除
;; (makunbound 'overriding-minor-mode-map)
(define-minor-mode overriding-minor-mode
  "強制的にC-c C-oを割り当てる"             ;説明文字列
  t                                     ;デフォルトで有効にする
  ""                                    ;モードラインに表示しない
  `(
    (,(kbd "C-c C-o") . other-frame)
    ;; helm-swoop
    (, (kbd "C-c C-s") . helm-swoop)
    ))

; EMP用スクロール設定 効いていない？
(setq scroll-conservatively 35
  scroll-margin 0
  scroll-step 1)

; 24.4用フォント設定
(set-face-attribute 'default nil :family "Menlo" :height 140)
(if (display-graphic-p)
    (set-fontset-font (frame-parameter nil 'font)
                      'japanese-jisx0208
                      (font-spec :family "Hiragino Kaku Gothic ProN")))
(add-to-list 'face-font-rescale-alist
             '(".*Hiragino Kaku Gothic ProN.*" . 1.2))




;; 透明度を変更するコマンド M-x set-alpha
;; http://qiita.com/marcy@github/items/ba0d018a03381a964f24
(defun set-alpha (alpha-num)
  "set frame parameter 'alpha"
  (interactive "nAlpha: ")
  (set-frame-parameter nil 'alpha (cons alpha-num '(90))))

;; インクリメンタル中に検索キーワードをBSで削除
(define-key isearch-mode-map "\C-h" 'isearch-delete-char)


;; git
(unless (package-installed-p 'magit)
  (package-refresh-contents) (package-install 'magit))

;; neotree
(unless (package-installed-p 'neotree)
  (package-refresh-contents) (package-install 'neotree))

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
