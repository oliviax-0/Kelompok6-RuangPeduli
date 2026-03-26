from django.core.management.base import BaseCommand
from accounts.models import User
from profiles.models import OrphanageProfile

PANTI_DATA = [
    {
        'username': 'panti_mekar_lestari',
        'email': 'mekar.lestari@ruangpeduli.id',
        'password': 'panti123',
        'nama_panti': 'Panti Asuhan Mekar Lestari',
        'alamat_panti': (
            'Jalan Komersial III, Sektor 1.5, Jl. Lavionda Blok B1 No.1, '
            'Lengkong Gudang Timur, Serpong, Kota Tangerang Selatan, Banten 15310'
        ),
        'nomor_panti': '+622153153088',
        'description': 'Panti asuhan yang berdiri sejak 2005, melayani anak-anak yatim piatu di wilayah Serpong dan sekitarnya.',
    },
    {
        'username': 'panti_kasih_sesama',
        'email': 'kasih.sesama@ruangpeduli.id',
        'password': 'panti123',
        'nama_panti': 'Panti Asuhan Kasih Sesama',
        'alamat_panti': (
            'Jl. Benda Raya / Benda Barat VI, Pamulang, '
            'Kota Tangerang Selatan, Banten 15416'
        ),
        'nomor_panti': '+62217405720',
        'description': 'Panti asuhan yang berfokus pada pendidikan dan pemberdayaan anak-anak kurang mampu di Pamulang.',
    },
    {
        'username': 'yayasan_sayap_ibu',
        'email': 'sayap.ibu@ruangpeduli.id',
        'password': 'panti123',
        'nama_panti': 'Yayasan Sayap Ibu Cabang Banten',
        'alamat_panti': (
            'Jl. Raya Graha Utama No. 33B, Kel. Pondok Kacang Barat, '
            'Tangerang Selatan, Banten 15226'
        ),
        'nomor_panti': '(021)7331004',
        'description': 'Cabang Banten dari Yayasan Sayap Ibu, melayani anak-anak terlantar dan difabel sejak 1955.',
    },
]


class Command(BaseCommand):
    help = 'Seed 3 dummy panti asuhan accounts into the database'

    def handle(self, *args, **options):
        created_count = 0
        skipped_count = 0

        for data in PANTI_DATA:
            if User.objects.filter(username=data['username']).exists():
                self.stdout.write(f"  Skipped (already exists): {data['nama_panti']}")
                skipped_count += 1
                continue

            user = User.objects.create_user(
                username=data['username'],
                email=data['email'],
                password=data['password'],
                role='panti',
            )
            OrphanageProfile.objects.create(
                user=user,
                nama_panti=data['nama_panti'],
                alamat_panti=data['alamat_panti'],
                nomor_panti=data['nomor_panti'],
                description=data['description'],
            )
            self.stdout.write(self.style.SUCCESS(f"  Created: {data['nama_panti']}"))
            created_count += 1

        self.stdout.write(
            self.style.SUCCESS(
                f"\nDone. {created_count} panti created, {skipped_count} skipped."
            )
        )
