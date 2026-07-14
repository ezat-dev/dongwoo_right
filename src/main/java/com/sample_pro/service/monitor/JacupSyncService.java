package com.sample_pro.service.monitor;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class JacupSyncService {

    private static final Logger log = LoggerFactory.getLogger(JacupSyncService.class);

    @Resource(name = "htmsSession")
    private SqlSession htmsSession;

    @Resource(name = "session")
    private SqlSession localSession;

    // htms(192.168.4.4) 직접 연결로 전환 — 동기화 불필요, 비활성화
    // @Scheduled(fixedDelay = 20000)
    public void sync() {
        try {
            // 로컬에 이미 있는 키 수집
            List<String> existingKeys = localSession.selectList("JacupLocalMapper.selectExistingKeys");
            Set<String> existingSet = new HashSet<>(existingKeys);

            // htms에서 조회
            List<Map<String, Object>> htmsList = htmsSession.selectList("JacupSyncMapper.selectFromHtms");

            int inserted = 0;
            for (Map<String, Object> row : htmsList) {
                String key = (String) row.get("WORK_INDCT_NUM");
                if (key == null || existingSet.contains(key)) continue;
                localSession.insert("JacupLocalMapper.insertOne", row);
                inserted++;
            }

            if (inserted > 0) {
                log.info("[JacupSync] {} 건 신규 INSERT", inserted);
            }
        } catch (Exception e) {
            log.error("[JacupSync] 동기화 오류: {}", e.getMessage());
        }
    }
}
