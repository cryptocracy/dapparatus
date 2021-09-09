;;;; Like Universal Value
(define-constant ERR_INVALID_CONTENT u0)
(define-constant ERR_CANNOT_LIKE_NON_EXISTENT_CONTENT u1)
(define-constant LUV_TREASURY 'ST1ZG09W7XN7S1WH5F06YN25C5CGK2RE01D6CSA1H)

;;;; Data maps and vars
(define-data-var content-index uint u0)

(define-read-only (get-content-index)
  (ok (var-get content-index)))


(define-map like-state
  { content-index: uint}
  { likes: uint})


(define-map publisher-state
  { content-index: uint}
  { publisher: principal})


(define-read-only (get-like-count (id uint))
  (ok (default-to { likes: u0 } (map-get? like-state { content-index: id}))))


(define-read-only (get-message-publisher (id uint))
  (ok (unwrap-panic (get publisher (map-get? publisher-state { content-index: id})))))


;;;; Private functions
(define-private (increment-content-index)
  (begin
    (var-set content-index (+ (var-get content-index) u1))
    (ok (var-get content-index))))
  


(define-private (get-balance (recipient principal))
  (contract-call? 'ST1ZG09W7XN7S1WH5F06YN25C5CGK2RE01D6CSA1H.luv-token get-balance recipient))


;;;; Public functions
(define-public (send-message (content (string-utf8 140) ) (attachment-uri (optional (string-utf8 256))))
  (let ((id (unwrap! (increment-content-index) (err u0))))
    (print { content: content, publisher: tx-sender, index: id, attachment-uri: attachment-uri})
    (map-set like-state
      { content-index: id}
      { likes: u0})
    
    (map-set publisher-state
      { content-index: id}
      { publisher: tx-sender})
    
    (transfer-luv u1 LUV_TREASURY)))
  


(define-public (like-message (id uint))
  (begin
    (asserts! (>= (var-get content-index) id) (err ERR_CANNOT_LIKE_NON_EXISTENT_CONTENT))
    (map-set like-state
      { content-index: id}
      { likes: (+ u1 (get likes (unwrap! (get-like-count id) (err u0))))})
    
    (transfer-luv u1 (unwrap-panic (get-message-publisher id)))))
  


;;;; Token contract interactions
(define-public (transfer-luv (amount uint) (recipient principal))
  (contract-call? 'ST1ZG09W7XN7S1WH5F06YN25C5CGK2RE01D6CSA1H.luv-token transfer amount tx-sender recipient none))