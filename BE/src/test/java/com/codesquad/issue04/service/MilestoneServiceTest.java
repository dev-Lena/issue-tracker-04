package com.codesquad.issue04.service;

import static org.assertj.core.api.Assertions.*;

import java.time.LocalDate;
import java.util.List;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.codesquad.issue04.domain.milestone.Milestone;
import com.codesquad.issue04.web.dto.request.MilestoneCreateRequestDto;
import com.codesquad.issue04.web.dto.response.milestone.MilestoneDto;
import com.codesquad.issue04.web.dto.response.milestone.MilestoneResponseDtos;

@SpringBootTest
public class MilestoneServiceTest {

	@Autowired
	private MilestoneService milestoneService;

	@DisplayName("마일스톤을 아이디로 검색한다.")
	@Test
	void 마일스톤을_아이디로_검색한다() {
		assertThat(milestoneService.findMilestoneById(1L)).isInstanceOf(Milestone.class);
	}

	@DisplayName("마일스톤 전체가 리스트로 반환된다.")
	@Test
	void 마일스톤_전체가_리스트로_반환된다() {
		assertThat(milestoneService.findAllMilestones()).isInstanceOf(List.class);
		assertThat(milestoneService.findAllMilestones().get(0)).isInstanceOf(Milestone.class);
	}

	@DisplayName("마일스톤 전체가 DTO 형태로 리스트에 반환된다.")
	@Test
	void 마일스톤_전체가_DTO로_리스트에_반환된다() {
		assertThat(milestoneService.getAllMilestones()).isInstanceOf(List.class);
		assertThat(milestoneService.getAllMilestones().get(0)).isInstanceOf(MilestoneDto.class);
	}

	@DisplayName("마일스톤 DTO 전체가 일급 콜렉션 형태로 변환된다.")
	@Test
	void 마일스톤_전체가_일급콜렉션으로_DTO에_리턴된다() {
		assertThat(milestoneService.getMilestoneOverviews()).isInstanceOf(MilestoneResponseDtos.class);
	}

	@DisplayName("마일스톤 하나를 추가한다.")
	@CsvSource({"testTitle, 2020-06-30, testContent"})
	@ParameterizedTest
	void 마일스톤_하나를_추가한다(String title, LocalDate dueDate, String content) {
		MilestoneCreateRequestDto dto = new MilestoneCreateRequestDto(title, dueDate, content);
		Milestone milestone = Milestone.builder()
			.title(dto.getTitle())
			.description(dto.getDescription())
			.dueDate(dto.getDueDate())
			.build();
		Milestone savedItem = milestoneService.createMilestone(milestone);
		assertThat(savedItem.getTitle()).isEqualTo(milestone.getTitle());
	}
}
