;;; dap-chrome.el --- Debug Adapter Protocol mode for Chrome      -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Ivan Yonchovski

;; Author: Ivan Yonchovski <yyoncho@gmail.com>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; URL: https://github.com/yyoncho/dap-mode
;; Package-Requires: ((emacs "25.1") (dash "2.14.1") (lsp-mode "4.0"))
;; Version: 0.2

;;; Commentary:
;; Adapter for https://github.com/chromeide/vscode-chrome

;;; Code:

(require 'dap-mode)
(require 'dap-utils)

(defcustom dap-chrome-debug-path (expand-file-name "vscode/msjsdiag.debugger-for-chrome"
                                                   dap-utils-extension-path)
  "The path to chrome vscode extension."
  :group 'dap-chrome
  :type 'string)

(defcustom dap-chrome-debug-program `("node"
                                      ,(f-join dap-chrome-debug-path "extension/out/src/chromeDebug.js"))
  "The path to the chrome debugger."
  :group 'dap-chrome
  :type '(repeat string))

(dap-utils-vscode-setup-function "dap-chrome" "msjsdiag" "debugger-for-chrome"
                                 dap-chrome-debug-path)

(defun dap-chrome--populate-start-file-args (conf)
  "Populate CONF with the required arguments."
  (-> conf
      (dap--put-if-absent :dap-server-path dap-chrome-debug-program)
      (dap--put-if-absent :type "chrome")
      (dap--put-if-absent :cwd default-directory)
      (dap--put-if-absent :file (read-file-name "Select the file to open in the browser:" nil (buffer-file-name) t))
      (dap--put-if-absent :name "Chrome Debug")))

(dap-register-debug-provider "chrome" #'dap-chrome--populate-start-file-args)

(dap-register-debug-template "Chrome Run Configuration"
                             (list :type "chrome"
                                   :cwd nil
                                   :request "launch"
                                   :file nil
                                   :reAttach t
                                   :program nil
                                   :name "Chrome::Run"))

(provide 'dap-chrome)
;;; dap-chrome.el ends here
