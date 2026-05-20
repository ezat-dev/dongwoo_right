package com.sample_pro.dao.management;

import com.sample_pro.domain.Product;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class ProductInsertDaoImpl implements ProductInsertDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    
}
