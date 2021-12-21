require "lightspeed".setup {
    jump_on_partial_input_safety_timeout = 400,
    highlight_unique_chars = true,
    grey_out_search_area = true,
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
