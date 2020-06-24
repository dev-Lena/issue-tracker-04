package com.codesquad.issue04.web.controller;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.codesquad.issue04.domain.milestone.Milestone;
import com.codesquad.issue04.service.MilestoneService;
import com.codesquad.issue04.web.dto.request.MilestoneCreateRequestDto;
import com.codesquad.issue04.web.dto.request.MilestoneUpdateRequestDto;
import com.codesquad.issue04.web.dto.response.milestone.MilestoneDto;
import com.codesquad.issue04.web.dto.response.milestone.MilestoneResponseDtos;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("api")
public class MilestoneController {

    private final MilestoneService milestoneService;

    @GetMapping("v1/allMilestones")
    public MilestoneResponseDtos getAllMilestones() {
        return milestoneService.getMilestoneOverviews();
    }

    @PostMapping("v1/milestone")
    public Milestone createMilestone(@RequestBody MilestoneCreateRequestDto milestoneCreateRequestDto) {
        return milestoneService.createMilestone(milestoneCreateRequestDto);
    }

    @PutMapping("v1/milestone")
    public MilestoneDto updateMilestone(@RequestBody MilestoneUpdateRequestDto milestoneUpdateRequestDto) {
        return milestoneService.updateMilestone(milestoneUpdateRequestDto);
    }

    @DeleteMapping("v1/milestone/{milestoneId}")
    public Milestone deleteMilestone(@PathVariable Long milestoneId) {
        return milestoneService.deleteMilestone(milestoneId);
    }
}
