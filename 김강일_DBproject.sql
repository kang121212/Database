-- 학과 테이블 생성
create table dept(
    dept_no number(3) primary key,
    dept_name varchar2(50) not null
    );
    
-- 교수 테이블 생성
create table prof(
    prof_no number(5) primary key,
    prof_name varchar2(30) not null,
    prof_birth varchar2(10),
    prof_phone varchar2(20),
    dept_no number(3),
    constraint fk_prof_dept foreign key (dept_no) REFERENCES dept(dept_no)
    );

-- 학생 테이블 생성
create table student(
    student_no number(8) primary key,
    student_name varchar2(30) not null,
    student_birth varchar2(10),
    student_phone varchar2(20),
    student_gender varchar2(1),
    dept_no number(3),
    advisor_no number(5),
    constraint fk_student_dept foreign key (dept_no) references dept(dept_no),
    constraint fk_student_prof foreign key (advisor_no) REFERENCES prof(prof_no)
    );

-- 과목 테이블 생성
create table subject(
    subject_no varchar2(10) primary key,
    subject_name varchar2(50) not null,
    room_info varchar2(30),
    subject_time varchar2(50),
    prof_no number(5),
    constraint fk_subject_prof foreign key (prof_no) REFERENCES prof(prof_no)
    );

-- 수강하다 테이블 생성 (M:N) 관계 시 테이블을 따로 생성해야함
create table enroll(
    student_no number(8),
    subject_no varchar2(10),
    score number(3,2),
    constraint pk_enroll primary key (student_no, subject_no),
    constraint fk_enroll_student foreign key (student_no) REFERENCES student(student_no),
    constraint fk_enroll_subject foreign key (subject_no) REFERENCES subject(subject_no)
    );

-- 학과 데이터 입력 INSERT
insert into dept values(10, '전자과');
insert into dept values(20, '전기과');
insert into dept values(30, '기계과');
insert into dept values(40, '금속과');
insert into dept values(50, '간호학과');
insert into dept values(60, '경영학과');

-- 교수 데이터 입력 INSERT
insert into prof values(1001, '김전자', '1970-05-10', '010-1111-9999', 10);
insert into prof values(2001, '박전기', '1975-08-20', '010-1111-9999', 20);
insert into prof values(3001, '최기계', '1968-01-15', '010-3333-9999', 30);
insert into prof values(4001, '이금속', '1980-11-11', '010-4444-9999', 40);
insert into prof values(5001, '나이팅', '1972-12-25', '010-5555-9999', 50);
insert into prof values(6001, '정경영', '1965-03-01', '010-6666-9999', 60);

-- 학생 데이터 입력 INSERT
insert into student values(2024001, '홍길동', '2005-01-01', '010-1111-1111', 'M', 10, 1001); 
insert into student values(2024002, '성춘향', '2005-03-15', '010-2222-2222', 'F', 50, 5001);
insert into student values(2024003, '이몽룡', '2004-12-25', '010-3333-3333', 'M', 30, 3001);
insert into student values(2024004, '심청이', '2005-07-07', '010-4444-4444', 'F', 60, 6001);
insert into student values(2024005, '강철수', '2003-05-05', '010-5555-5555', 'M', 40, 4001);
insert into student values(2024006, '이영희', '2005-09-09', '010-6666-6666', 'F', 20, 2001);

-- 과목 데이터 입력 INSERT
insert into subject values('el01', '회로이론', '공학관101', '월요일 10:00', 1001);
insert into subject values('nu01', '기본간호학', '간호관202', '화요일 14:00', 5001);
insert into subject values('me01', '기계이론', '공학관303', '수요일 09:00', 3001);
insert into subject values('mt01', '재료공학', '공학관105', '목요일 13:00', 4001);
insert into subject values('bz01', '마케팅이론', '경영관404', '금요일 10:00', 6001);

-- 수강 데이터 입력 INSERT
insert into enroll values (2024001, 'el01', 4.5);
insert into enroll values (2024001, 'me01', 3.5);
insert into enroll values (2024002, 'nu01', 4.0);
insert into enroll values (2024003, 'me01', 3.0);
insert into enroll values (2024004, 'bz01', 4.5);
insert into enroll values (2024005, 'mt01', null);
insert into enroll values (2024006, 'el01', 3.8);

commit;

--====================SQL 질의문================
--1. 전체 학생의 목록을 조회
select * from student;

--2. 간호학과에 소속된 학생들의 명단 조회
select student_name, student_no
from student
where dept_no = (select dept_no from dept where dept_name='간호학과');

--3. 여학생들의 학번과 이름을 조회
select student_no, student_name
from student
where student_gender='F';

--4. 2005년에 태어난 학생들을 조회
select student_name, student_birth
from student
where student_birth like '2005%';

--5. 교수 직번이 2001번인 교수님의 이름과, 전화번호를 조회
select prof_name, prof_phone
from prof
where prof_no=2001;

--6. 공학관 건물에서 수업하는 과목을 조회
select subject_name, room_info
from subject
where room_info like '공학관%';

--7. 성적이 4.0 이상인 수강 내역을 조회
select student_no, subject_no, score
from enroll
where score >= 4.0;

--8. 아직 성적이 입력되지 않은(null) 수강내역을 조회하시오.
select student_no, subject_no
from enroll
where score is null;

--9. 월요일에 수업이 있는 과목명을 조회
select subject_name, subject_time
from subject
where subject_time like '월요일%';

--10. 모든 학생을 이름 순서대로 오른차순 정렬
select *
from student order by student_name ASC;

--11. 전체 학생 수를 구하시오
select count(*) as 전체학생수
from student;

--12. 학생들의 전체 평균 학점을 소수점 셋째 자리 반올림 하기
select round(avg(score), 2) as 평균학점
from enroll;

--13. 과목별로 수강 신청한 학생 수를 조회
select subject_no, count(*) as 수강생수
from enroll group by subject_no;

--14. 가장 높은 학점을 받은 사람의 학번과 학점을 조회
select student_no, score
from enroll
where score = (select max(score) from enroll);

--15. '공학관' 강의실을 사용하는 과목의 갯수
select count(*) as 공학관개수
from subject
where room_info like '공학관%';

--16. 성별별 학생 수를 조회
select student_gender, count(*) as 학생수
from student group by student_gender;

--17. 학생 이름과 소속 학과명을 함께 조회
select s.student_name, d.dept_name
from student s join dept d on s.dept_no=d.dept_no;


--18. 학생 이름과 그 학생의 지도교수 이름을 조회
select s.student_name as 학생명, p.prof_name as 지도교수명
from student s join prof p on s.advisor_no= p.prof_no;

--19. 교수 이름과 그 교수가 담당하는 과목명 조회
select p.prof_name, s.subject_name
from prof p join subject s on p.prof_no = s.prof_no;

--20. 수강생의 이름, 수강 과목명, 학점을 조회
select s.student_name, sub.subject_name, e.score
from enroll e
join student s on e.student_no = s.student_no
join subject sub on e.subject_no = sub.subject_no;

--21. 전자과에 소속된 학생들의 지도교수 이름을 조회
select s.student_name, p.prof_name
from student s
join prof p on s.advisor_no = p.prof_no
where s.dept_no = (select dept_no from dept where dept_name='전자과');

--22. 학과별로 소속된 교수의 수를 조회
select d.dept_name, count(p.prof_no) as 교수의수
from dept d
left join prof p on d.dept_no = p.dept_no
group by d.dept_name;

--23. 수강 신청을 한 과목이 하나도 없는 학생을 조회
select student_name 
from student
where student_no not in (select distinct student_no from enroll);

--24. 전체 평균 점수보다 높은 점수를 받은 수강 내역을 조회
select student_no, subject_no, score
from enroll
where score > (select avg(score) from enroll);

--25. 자신이 소속된 학과와 같은 학과에 소속된 교수에게 지도받지 않는 학생을 조회
select s.student_name, d.dept_name as 학생학과, p.prof_name as 지도교수
from student s
join prof p on s.advisor_no = p.prof_no
join dept d on s.dept_no = d.dept_no
where s.dept_no != p.dept_no;

--26. 가장 높은 점수(max score)을 받은 학생의 이름과 과목명을 조회
select s.student_name, sub.subject_name
from enroll e
join student s on e.student_no = s.student_no
join subject sub on e.subject_no = sub.subject_no
where e.score = (select max(score) from enroll);

--27. 학생 이름과 그 학생이 수강한 과목 수를 함께 조회하시오.
select student_name, (select count(*) from enroll where student_no=s.student_no) as 수강과목수
from student s;

--28. 학번 2024001인 학생의 전화번호를 010-9876-5432로 변경
update student set student_phone = '010-9876-5432' where student_no=2024001;

--29. 성적이 null인 수강 데이터를 삭제
delete from enroll where score is null;

--30. 학생, 과목, 학점 정보를 포함하는 성적표 뷰를 생성
create or replace view v_transcript as
select s.student_name, sub.subject_name, e.score
from enroll e
join student s on e.student_no = s.student_no
join subject sub on e.subject_no = sub.subject_no;

-- 30-1 생성된 뷰 조회
select * from v_transcript;

-- 31. 학생정보 + 소속학과 조회
select s.student_name, d.dept_name
from student s
join dept d on s.dept_no = d.dept_no
where d.dept_name in ('전자과', '기계과', '전기과');

-- 32. 학과별 교수 수 조회
select d.dept_name, count(p.prof_no) as 교수수
from dept d
left join prof p on d.dept_no = p.dept_no group by d.dept_name;

--33. 미수강 학생 조회
select s.student_name
from student s
left join enroll e on s.student_no = e.student_no and e.subject_no = 'me01'
where e.subject_no is null;

-- 34. 학생의 지도교수와 지도교수 소속 학과 조회
select s.student_name as 학생이름, p.prof_name as 지도교수이름, d.dept_name as 지도교수학과
from student s
join prof p on s.advisor_no = p.prof_no
join dept d on p.dept_no = d.dept_no;

-- 35. 특정 연도 이전 출생 교수의 담당 과목 조회
select c.subject_name, p.prof_name, p.prof_birth
from subject c
join prof p on c.prof_no = p.prof_no
where p.prof_birth<'1975-01-01';











