-- Tabel Member
CREATE TABLE "Member" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Tabel Librarian
CREATE TABLE "Librarian" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Tabel Categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Tabel Bookshelf
CREATE TABLE bookshelf (
    id SERIAL PRIMARY KEY,
    code VARCHAR(25) NOT NULL,
    category_id INT REFERENCES categories(id) ON DELETE CASCADE
);

-- Tabel Book 
CREATE TABLE book (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category_id INT REFERENCES categories(id) ON DELETE CASCADE,
    bookshelf_id INT REFERENCES bookshelf(id) ON DELETE CASCADE
);

-- Tabel Borrowing
CREATE TABLE borrowing (
    id SERIAL PRIMARY KEY,
    member_id INT REFERENCES "Member"(id) ON DELETE CASCADE,
    librarian_id INT REFERENCES "Librarian"(id) ON DELETE CASCADE,
    book_id INT REFERENCES book(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Member 
INSERT INTO "Member" (name) VALUES 
('Habib Muhammad Rizki'), ('Zulfikar Alfiansyah'), ('Argo Nugroho'), ('Wanda Putri Kartika'), ('Renata Prameswari'),
('Almaruf Hidayat'), ('Raden Anggoro'), ('Maulana Muhammad Ardansyah'), ('Audina Alamanda'), ('Joko Pidodo');

--  Librarian 
INSERT INTO "Librarian" (name) VALUES 
('Ahmad Fauzi'), ('Bambang Sugiarto'), ('Citra Kirana'), ('Rizki Faiq Pradana'), ('Fajar Nugraha'),
('Adkiya'), ('Ircham Yasir'), ('Indah Restanti'), ('Joni Iskandar'), ('Dwi Endah');

--  Categories 
INSERT INTO categories (name) VALUES 
('Teknologi'), ('Fiksi'), ('Sejarah'), ('Sains'), ('Biografi'),
('Ekonomi'), ('Filsafat'), ('Seni & Desain'), ('Pendidikan'), ('Agama');

--  Bookshelf 
INSERT INTO bookshelf (code, category_id) VALUES 
('TEC-01', 1), ('FIC-01', 2), ('HIS-01', 3), ('SCI-01', 4), ('BIO-01', 5),
('ECO-01', 6), ('PHI-01', 7), ('ART-01', 8), ('EDU-01', 9), ('REL-01', 10);

--  Book 
INSERT INTO book (title, category_id, bookshelf_id) VALUES 
('Belajar PostgreSQL Dasar', 1, 1),
('Laskar Pelangi', 2, 2),
('Sejarah Dunia Yang Disembunyikan', 3, 3),
('Fisika Kuantum untuk Pemula', 4, 4),
('Biografi Steve Jobs', 5, 5),
('Ekonomi Makro', 6, 6),
('Dunia Sophie', 7, 7),
('Pengantar Desain Grafis', 8, 8),
('Strategi Pembelajaran Modern', 9, 9),
('Fiqih Muamalah Kontemporer', 10, 10);

--  Borrowing 
INSERT INTO borrowing (member_id, librarian_id, book_id, created_at) VALUES 
(1, 1, 1, '2026-09-01 09:30:00'),
(2, 2, 2, '2026-09-02 10:15:00'),
(3, 3, 3, '2026-09-03 11:00:00'),
(4, 4, 4, '2026-09-04 13:20:00'),
(5, 5, 5, '2026-09-05 14:00:00'),
(6, 6, 6, '2026-09-06 08:45:00'),
(7, 7, 7, '2026-09-07 10:00:00'),
(8, 8, 8, '2026-09-08 11:30:00'),
(9, 9, 9, '2026-09-09 15:10:00'),
(10, 10, 10, '2026-09-10 16:00:00');