;; frame-movement:
;; switch Emacs frames left/right

(provide 'frame-movement)

(defun frame-movement/frame-rowmajor (frame-a frame-b)
  (let* ((frame-a-pos (frame-position frame-a))
	 (ax (car frame-a-pos))
	 (ay (cdr frame-a-pos))
	 (frame-b-pos (frame-position frame-b))
	 (bx (car frame-b-pos))
	 (by (cdr frame-b-pos)))
    (and (<= ay by)
	 (<= ax bx))))

(defun frame-movement/sort-by-position (framelist)
  (sort framelist #'frame-movement/frame-rowmajor))

(defun frame-movement/select-frame-offset (offset)
  (let* ((sorted-frames-vector (vconcat
				(frame-movement/sort-by-position
				 (visible-frame-list))))
	 (current-frame-index (seq-position sorted-frames-vector 
					    (selected-frame)))
	 (target-index (mod (+ current-frame-index offset) 
			    (length sorted-frames-vector)))
	 (target-frame (elt sorted-frames-vector target-index)))
    (select-frame-set-input-focus target-frame)))

(defun frame-movement/select-next-frame (arg)
  (interactive "p")
  (frame-movement/select-frame-offset arg))

(defun frame-movement/select-prev-frame (arg)
  (interactive "p")
  (frame-movement/select-frame-offset (- arg)))

(global-set-key (kbd "C-x 5 n") 'frame-movement/select-next-frame)
(global-set-key (kbd "C-x 5 p") 'frame-movement/select-prev-frame)
