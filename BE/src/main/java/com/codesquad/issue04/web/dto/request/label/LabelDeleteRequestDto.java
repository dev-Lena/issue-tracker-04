package com.codesquad.issue04.web.dto.request.label;

import lombok.Getter;

@Getter
public class LabelDeleteRequestDto {
	private Long id;

	public LabelDeleteRequestDto(Long id) {
		this.id = id;
	}
}
