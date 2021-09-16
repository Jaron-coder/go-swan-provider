package models

type Miner struct {
    Id             int     `json:"id"`
    MinerFid       string  `json:"miner_fid"`
    BidMode        int     `json:"bid_mode"`
    StartEpoch     int     `json:"start_epoch"`
    Price          float64 `json:"price"`
    VerifiedPrice  float64 `json:"verified_price"`
    MinPieceSize   string  `json:"min_piece_size"`
    MaxPieceSize   string  `json:"max_piece_size"`
}
