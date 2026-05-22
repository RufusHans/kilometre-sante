-- Seed pharmacies Pointe-Noire (exécuter après 001_schema.sql)
-- Les produits sont insérés par pharmacie via legacy_id

TRUNCATE products, pharmacies CASCADE;

INSERT INTO pharmacies (legacy_id, name, arrondissement, quartier, phone, hours, is_on_duty, image_url) VALUES
('ph-001', 'Pharmacie de la Poste', '1er Arrondissement', 'Centre-ville', '+242 06 512 34 01', 'Lun-Sam 8h-20h | Dim 9h-13h', true, 'https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=400&h=240&fit=crop'),
('ph-002', 'Pharmacie Mavré', '2e Arrondissement', 'Tié-Tié', '+242 06 523 45 12', 'Lun-Sam 7h30-21h', true, 'https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=400&h=240&fit=crop'),
('ph-003', 'Pharmacie de la Frontière', '3e Arrondissement', 'Mpaka', '+242 06 534 56 23', 'Lun-Dim 8h-22h', false, 'https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=400&h=240&fit=crop'),
('ph-004', 'Pharmacie du Port', '1er Arrondissement', 'Port de Pointe-Noire', '+242 06 545 67 34', 'Lun-Sam 8h-19h', false, 'https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=400&h=240&fit=crop'),
('ph-005', 'Pharmacie Loandjili', '4e Arrondissement', 'Loandjili', '+242 06 556 78 45', 'Lun-Sam 7h-20h | Dim fermé', true, 'https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=400&h=240&fit=crop'),
('ph-006', 'Pharmacie Ngoyo', '5e Arrondissement', 'Ngoyo', '+242 06 567 89 56', 'Lun-Sam 8h-21h', false, 'https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=400&h=240&fit=crop'),
('ph-007', 'Pharmacie Mvou-Mvou', '2e Arrondissement', 'Mvou-Mvou', '+242 06 578 90 67', 'Lun-Sam 8h-20h', false, 'https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=400&h=240&fit=crop'),
('ph-008', 'Pharmacie Tié-Tié Plaza', '2e Arrondissement', 'Tié-Tié', '+242 06 589 01 78', 'Lun-Dim 7h30-22h', true, 'https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=400&h=240&fit=crop'),
('ph-009', 'Pharmacie Lumumba', '1er Arrondissement', 'Avenue Lumumba', '+242 06 590 12 89', 'Lun-Sam 8h-19h30', false, 'https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=400&h=240&fit=crop'),
('ph-010', 'Pharmacie Songolo', '3e Arrondissement', 'Songolo', '+242 06 601 23 90', 'Lun-Sam 7h30-20h30', false, 'https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=400&h=240&fit=crop'),
('ph-011', 'Pharmacie Tchimbamba', '4e Arrondissement', 'Tchimbamba', '+242 06 612 34 01', 'Lun-Sam 8h-20h', true, 'https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=400&h=240&fit=crop'),
('ph-012', 'Pharmacie Vindoulou', '5e Arrondissement', 'Vindoulou', '+242 06 623 45 12', 'Lun-Sam 8h-21h', false, 'https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=400&h=240&fit=crop'),
('ph-013', 'Pharmacie Diosso', '3e Arrondissement', 'Diosso', '+242 06 634 56 23', 'Lun-Sam 7h-19h', false, 'https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=400&h=240&fit=crop'),
('ph-014', 'Pharmacie La Base', '1er Arrondissement', 'La Base', '+242 06 645 67 34', 'Lun-Dim 8h-22h', true, 'https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=400&h=240&fit=crop'),
('ph-015', 'Pharmacie Grand Marché', '1er Arrondissement', 'Grand Marché', '+242 06 656 78 45', 'Lun-Sam 7h30-21h', false, 'https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=400&h=240&fit=crop'),
('ph-016', 'Pharmacie Cité Marine', '4e Arrondissement', 'Cité Marine', '+242 06 667 89 56', 'Lun-Sam 8h-20h', false, 'https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=400&h=240&fit=crop'),
('ph-017', 'Pharmacie Km4', '5e Arrondissement', 'Km4', '+242 06 678 90 67', 'Lun-Sam 8h-19h30', true, 'https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=400&h=240&fit=crop'),
('ph-018', 'Pharmacie Aeroport', '5e Arrondissement', 'Zone Aéroport', '+242 06 689 01 78', 'Lun-Dim 6h-23h', false, 'https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=400&h=240&fit=crop');

-- Produits (échantillon par pharmacie)
INSERT INTO products (pharmacy_id, name, price_fcfa, category, image_url, in_stock)
SELECT p.id, v.name, v.price_fcfa, v.category, v.image_url, v.in_stock
FROM pharmacies p
CROSS JOIN LATERAL (VALUES
  ('Paracétamol 500mg', 1500, 'Antalgique', 'https://images.unsplash.com/photo-1584308664744-24d5c474f2ae?w=120&h=120&fit=crop', true),
  ('Sérum physiologique', 2500, 'Soins', 'https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=120&h=120&fit=crop', true)
) AS v(name, price_fcfa, category, image_url, in_stock)
WHERE p.legacy_id = 'ph-001';

INSERT INTO products (pharmacy_id, name, price_fcfa, category, image_url, in_stock)
SELECT p.id, 'Ibuprofène 400mg', 2000, 'Antalgique', 'https://images.unsplash.com/photo-1584308664744-24d5c474f2ae?w=120&h=120&fit=crop', true FROM pharmacies p WHERE p.legacy_id = 'ph-002';

INSERT INTO products (pharmacy_id, name, price_fcfa, category, image_url, in_stock)
SELECT p.id, 'Amoxicilline 500mg', 5500, 'Antibiotique', 'https://images.unsplash.com/photo-1584308664744-24d5c474f2ae?w=120&h=120&fit=crop', true FROM pharmacies p WHERE p.legacy_id = 'ph-003';
