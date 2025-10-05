package com.finalapp.todos;

import com.finalapp.model.Todo;
import com.finalapp.model.User;
import com.finalapp.repository.TodoRepository;
import com.finalapp.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class TodosApplicationTests {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private TodoRepository todoRepo;

    @Test
    @Transactional
    void testCreateAndFindTodo() {
        //Create and save user
        User user = new User();
        user.setUsername("testtest");
        user.setPassword("testpwd");
        user = userRepo.saveAndFlush(user);

        //Create and save todo
        Todo todo = new Todo();
        todo.setTitle("Test Todo");
        todo.setDescription("just a test");
        todo.setCompleted(false);
        todo.setUser(user);
        todo = todoRepo.save(todo);

        //Retrieve todo
        Todo fetched = todoRepo.findById(todo.getId()).orElseThrow();

        //
        assertThat(fetched.getTitle()).isEqualTo("Test Todo");
        assertThat(fetched.getUser().getUsername()).isEqualTo("testtest");
        assertThat(fetched.getCompleted()).isFalse();
    }
}
