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
    (and (<= ax bx)
	 (<= ay by))))

(defun frame-movement/sort-by-position (framelist)
  (sort framelist #'frame-movement/frame-rowmajor))

(defun frame-movement/find-next-frame-recursive (frame first-frame frame-list)
  (cond ((null frame-list) first-frame)
	((eq frame (car frame-list)) (if (null (cdr frame-list))
					 first-frame
				       (car (cdr frame-list))))
	(t (frame-movement/find-next-frame-recursive frame
						     first-frame
						     (cdr frame-list)))))

(defun frame-movement/goto-next-frame ()
  (interactive)
  (let* ((sorted-frames (frame-movement/sort-by-position (visible-frame-list)))
	 (zero-frame (car sorted-frames))
	 (target-frame
	  (frame-movement/find-next-frame-recursive (selected-frame)
						    zero-frame
						    sorted-frames)))
    (select-frame-set-input-focus target-frame)))

(defun frame-movement/goto-prev-frame ()
  (interactive)
  (let* ((sorted-frames (reverse (frame-movement/sort-by-position
				  (visible-frame-list))))
	 (zero-frame (car sorted-frames))
	 (target-frame
	  (frame-movement/find-next-frame-recursive (selected-frame)
						    zero-frame
						    sorted-frames)))
    (select-frame-set-input-focus target-frame)))

(global-set-key (kbd "C-x [") 'frame-movement/goto-next-frame)
(global-set-key (kbd "C-x ]") 'frame-movement/goto-prev-frame)
(global-set-key (kbd "C-x 5 n") 'frame-movement/goto-next-frame)
(global-set-key (kbd "C-x 5 p") 'frame-movement/goto-prev-frame)

