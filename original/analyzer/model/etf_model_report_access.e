note
	description: "Singleton access to the system model report messages."
	author: "Ashkan Moatamed"

frozen expanded class
	ETF_MODEL_REPORT_ACCESS

feature -- Constant Report Strings

	report_ok: IMMUTABLE_STRING_8
		once
			Result := "OK."
		end

	report_initialized: IMMUTABLE_STRING_8
		once
			Result := "Expression is initialized."
		end

	report_cannot_reset: IMMUTABLE_STRING_8
		once
			Result := "Error (Initial expression cannot be reset)."
		end

	report_incomplete: IMMUTABLE_STRING_8
		once
			Result := "Error (Expression is not yet fully specified)."
		end

	report_complete: IMMUTABLE_STRING_8
		once
			Result := "Error (Expression is already fully specified)."
		end

	report_not_set_enum: IMMUTABLE_STRING_8
		once
			Result := "Error (Set enumeration is not being specified)."
		end

	report_empty_set_enum: IMMUTABLE_STRING_8
		once
			Result := "Error: (Set enumeration must be non-empty)."
		end

	report_division_by_zero: IMMUTABLE_STRING_8
		once
			Result := "Error (Divisor is zero)."
		end

	report_modulus_not_positive: IMMUTABLE_STRING_8
		once
			Result := "Error (Modulus is not positive)."
		end

	report_div_by_zero_and_mod_by_not_pos: IMMUTABLE_STRING_8
		once
			Result := "Error (Divisor is zero and Modulus is not positive)."
		end

	report_type_correct: IMMUTABLE_STRING_8
		once
			Result := " is type-correct."
		end

	report_not_type_correct: IMMUTABLE_STRING_8
		once
			Result := " is not type-correct."
		end

	report_incorrect_evaluation: IMMUTABLE_STRING_8
		once
			Result := "Error (Expression is not type-correct)."
		end

feature -- Report String Query

	is_valid_report (s: IMMUTABLE_STRING_8): BOOLEAN
		require
			argument_not_void: s /= Void
		do
			Result := (s ~ report_ok) or else (s ~ report_initialized) or else (s ~ report_cannot_reset)
					-- (in)complete statuses
				or else (s ~ report_incomplete) or else (s ~ report_complete)
					-- set_enum statuses
				or else (s ~ report_not_set_enum) or else (s ~ report_empty_set_enum)
					-- division by zero status
				or else (s ~ report_division_by_zero)
					-- modulus not positive status
				or else (s ~ report_modulus_not_positive)
					-- division by zero and modulus not positive status
				or else (s ~ report_div_by_zero_and_mod_by_not_pos)
					-- type incorrect status when evaluating
				or else (s ~ report_incorrect_evaluation)
		end

end
