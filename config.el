;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14 :weigt 'normal)
      doom-variable-pitch-font (font-spec :family "FiraMono Nerd Font" :size 15))
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; Custom theme
(setq doom-theme 'catppuccin)

;; protobuf highlighting
(use-package! protobuf-mode
  :defer-incrementally t)

;; relative line numbers in buffers
(setq display-line-numbers-type 'relative)


;; Set key bindings to open projectile project or current buffer in vscode
;;
;; Add these bindings to $EMACS_CONFIG_DIR/modules/os/macos/autoload.el
;; ;;;###autoload (autoload '+macos/reveal-project-in-vscode "os/macos/autoload" nil t)
;; (+macos--open-with reveal-project-in-vscode "Visual Studio Code"
;;                    (or (doom-project-root) default-directory))
;; ;;;###autoload (autoload '+macos/reveal-file-in-vscode "os/macos/autoload" nil t)
;; (+macos--open-with reveal-file-in-vscode "Visual Studio Code"
;;                    def-buffer)
;;
;; Open project
(map! :leader
      (:prefix-map ("o" . "open")
                   (:when (modulep! :os macos)
                     :desc "Reveal project in VS Code" "c" #'+macos/reveal-project-in-vscode)))
;; Open file (current buffer)
(map! :leader
      (:prefix-map ("o" . "open")
                   (:when (modulep! :os macos)
                     :desc "Reveal file in VS Code" "C" #'+macos/reveal-file-in-vscode)))

(after! apheleia
  (setf (alist-get 'ocp-indent apheleia-formatters)
        '("ocp-indent" buffer-file-name)))

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:ical-create-source
     "Qover"
     "~/Downloads/qover.ics"
     "IndianRed"))))

;; Open iCal Qover
(map! :leader
      (:prefix-map ("o" . "open")
       :desc "Open Qover Calendar" "Q" #'my-open-calendar))

(defun open-dir-of-current-file-vim ()
  (interactive)
  (async-shell-command
   (format "kitty -e nvim +%d %s"
           (+ (if (bolp) 1 0) (count-lines 1 (point)))
           (shell-quote-argument (vc-root-dir)))))

(map! :leader
      (:prefix-map ("o" . "open")
       :desc "Open project in nvim" "N" #'open-dir-of-current-file-vim))

;;copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; smudge config
(use-package! smudge
  :bind-keymap ("C-c ." . smudge-command-map)
  :custom
  (smudge-oauth2-client-secret "fb88b8eab52047edbb55b07f6648068e")
  (smudge-oauth2-client-id "4a60b0d87b3640cbae798d38274132e3")
  ;; optional: enable transient map for frequent commands
  (smudge-player-use-transient-map t))
