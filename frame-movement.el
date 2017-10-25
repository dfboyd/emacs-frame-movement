;; frame-movement:
;; switch Emacs frames left/right

(provide 'frame-movement)

(defun frame-movement/frame-rowmajor (frame-a frame-b)
  "Given two frame objects, dig out their X and Y coordinates,
and compare them in row-major order.  The first one is whichever
frame is closer to the top of the screen; of two frames at the
same height, the first one is on the left."
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
  "Find the frame that is OFFSET positions away from the currently-selected
frame in the list of all visible frames sorted by their X/Y positions,
and select-frame-set-input-focus it."
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
  "Switch to the ARG'th rightward adacent visible frame 
at the same height as the currently-selected frame.
If there are no more frames to the right in the same row,
go to the rightmost frame in the next row.  
Otherwise, wrap around to the highest leftmost frame."
  (interactive "p")
  (frame-movement/select-frame-offset arg))

(defun frame-movement/select-prev-frame (arg)
  "Switch to the ARG'th leftward adacent visible frame 
at the same height as the currently-selected frame.
If there are no more frames to the left in the same row,
go to the rightmost frame in the previous row.  
Otherwise, wrap around to the lowest rightmost frame."
  (interactive "p")
  (frame-movement/select-frame-offset (- arg)))

(global-set-key (kbd "C-x 5 n") 'frame-movement/select-next-frame)
(global-set-key (kbd "C-x 5 p") 'frame-movement/select-prev-frame)
