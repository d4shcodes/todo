package com.finalapp.repository;

import com.finalapp.model.Todo;
import com.finalapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TodoRepository extends JpaRepository<Todo, Long> {
    List<Todo> findByUserOrderByCompletedAsc(User user);
    List<Todo> findByUser(User user);
}
