require "lightspeed".setup {
    exit_after_idle_msecs = {unlabeled = 5000, labeled = nil},
    jump_to_unique_chars = true,
    match_only_the_start_of_same_char_seqs = true,
    limit_ft_matches = 5,
    substitute_chars = {["\r"] = "¬"},
    instant_repeat_fwd_key = nil,
    instant_repeat_bwd_key = nil,
    -- If no values are given, these will be set at runtime,
    -- based on `jump_to_first_match`.
    labels = nil,
    cycle_group_fwd_key = nil,
    cycle_group_bwd_key = nil
}
