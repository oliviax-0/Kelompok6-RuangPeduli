from django.core.management.base import BaseCommand
from django.contrib.auth.hashers import make_password
from accounts.models import User
from profiles.models import OrphanageProfile
from content.models import Berita, Video


PANTI_DATA = [
    {
        'username': 'sayap_ibu',
        'email': 'sayapibu@ruangpeduli.id',
        'nama_panti': 'Yayasan Sayap Ibu',
        'alamat_panti': 'Jl. Bintaro Utama Blok A5 No.12, Tangerang Selatan',
        'nomor_panti': '021-7456-8890',
    },
    {
        'username': 'al_hidayah',
        'email': 'alhidayah@ruangpeduli.id',
        'nama_panti': 'Panti Asuhan Al-Hidayah',
        'alamat_panti': 'Jl. Melati No. 5, Bandung',
        'nomor_panti': '022-1234567',
    },
    {
        'username': 'kasih_ibu',
        'email': 'kashibu@ruangpeduli.id',
        'nama_panti': 'Yayasan Kasih Ibu',
        'alamat_panti': 'Jl. Anggrek No. 3, Yogyakarta',
        'nomor_panti': '0274-987654',
    },
    {
        'username': 'griya_yatim',
        'email': 'griyayatim@ruangpeduli.id',
        'nama_panti': 'Griya Yatim Dhuafa',
        'alamat_panti': 'Jl. Raya Condet No. 27, Jakarta Timur',
        'nomor_panti': '021-8765432',
    },
    {
        'username': 'mekar_lestari',
        'email': 'mekarlestari@ruangpeduli.id',
        'nama_panti': 'Panti Asuhan Mekar Lestari',
        'alamat_panti': 'Jl. Komersial III, Sektor 1.5, Serpong, Tangerang Selatan',
        'nomor_panti': '021-53153088',
    },
    {
        'username': 'kasih_sesama',
        'email': 'kasihsesama@ruangpeduli.id',
        'nama_panti': 'Panti Asuhan Kasih Sesama',
        'alamat_panti': 'Jl. Benda Raya / Benda Barat VI, Pamulang, Tangerang Selatan',
        'nomor_panti': '021-7405720',
    },
    {
        'username': 'rumah_yatim',
        'email': 'rumahyatim@ruangpeduli.id',
        'nama_panti': 'Rumah Yatim Indonesia',
        'alamat_panti': 'Jl. Cipinang Muara Raya No. 40, Jakarta Timur',
        'nomor_panti': '021-8191234',
    },
    {
        'username': 'al_ikhlas',
        'email': 'alikhlas@ruangpeduli.id',
        'nama_panti': 'Panti Asuhan Al-Ikhlas',
        'alamat_panti': 'Jl. Kebon Jeruk Raya No. 15, Jakarta Barat',
        'nomor_panti': '021-5320987',
    },
    {
        'username': 'peduli_anak',
        'email': 'pedulianak@ruangpeduli.id',
        'nama_panti': 'Yayasan Peduli Anak',
        'alamat_panti': 'Jl. Sudirman No. 8, Surabaya',
        'nomor_panti': '031-5678901',
    },
    {
        'username': 'bina_insani',
        'email': 'binainsani@ruangpeduli.id',
        'nama_panti': 'Panti Asuhan Bina Insani',
        'alamat_panti': 'Jl. Gatot Subroto No. 22, Semarang',
        'nomor_panti': '024-7654321',
    },
]

BERITA_DATA = [
    {
        'panti_username': 'sayap_ibu',
        'title': 'Kegiatan Belajar Bersama Anak-Anak Panti',
        'content': (
            'Anak-anak panti asuhan mengikuti kegiatan belajar bersama yang dipandu oleh '
            'relawan dari berbagai perguruan tinggi. Kegiatan ini bertujuan untuk meningkatkan '
            'semangat belajar dan prestasi akademik anak-anak. Para relawan hadir setiap akhir '
            'pekan untuk memberikan bimbingan pelajaran mulai dari matematika, bahasa Indonesia, '
            'hingga bahasa Inggris.'
        ),
    },
    {
        'panti_username': 'al_hidayah',
        'title': 'Penyerahan Bantuan Sembako dari Donatur',
        'content': (
            'Panti asuhan menerima bantuan sembako dari para donatur yang peduli. Bantuan ini '
            'sangat berarti bagi anak-anak dan pengurus panti dalam memenuhi kebutuhan '
            'sehari-hari. Sebanyak 50 paket sembako diserahkan langsung oleh perwakilan '
            'donatur kepada kepala panti. Kami mengucapkan terima kasih yang sebesar-besarnya '
            'kepada seluruh donatur yang telah membantu.'
        ),
    },
    {
        'panti_username': 'kasih_ibu',
        'title': 'Peringatan Hari Anak Nasional 2026',
        'content': (
            'Dalam rangka memperingati Hari Anak Nasional, panti asuhan mengadakan berbagai '
            'lomba dan pertunjukan seni untuk menghibur anak-anak sekaligus mengasah bakat '
            'mereka. Lomba mewarnai, menyanyi, dan baca puisi menjadi daya tarik utama acara '
            'ini. Semua anak mendapatkan hadiah dan piagam penghargaan sebagai bentuk apresiasi '
            'atas partisipasi mereka.'
        ),
    },
    {
        'panti_username': 'sayap_ibu',
        'title': 'Sejarah Berdirinya Yayasan Sayap Ibu',
        'content': (
            'Yayasan Sayap Ibu berdiri pada tahun 1955, saat itu Ibu Sulistina yang tinggal '
            'bersama suaminya dirumah Dinas Sosial yang berada di Jalan Barito II No. 55 '
            'Kebayoran Baru, Jakarta Selatan.\n\n'
            'Pada saat itu Bung Tomo menjabat sebagai Menteri Sosial, Ibu Sulistina adalah '
            'istri yang senantiasa mendampingi dan membantu Bung Tomo. Tinggal di rumah Dinas '
            'Sosial setiap hari ia mendapati sebuah pemandangan yang miris didepan rumahnya.\n\n'
            'Setiap hari ia melihat para ibu \u2013 ibu yang berdagang dijalanan tersebut '
            'membawa anak \u2013 anaknya yang masih sangat kecil dan rentan terkena penyakit '
            'untuk berjualan.\n\n'
            '\U0001f4de Telepon: 021-7456-8890\n'
            '\U0001f4ac WhatsApp: https://wa.me/6281299988776\n'
            '\U0001f4cd Alamat: Jl. Bintaro Utama Blok A5 No.12, Tangerang Selatan\n'
            '\U0001f551 Jam operasional: 08.00 \u2013 17.00 WIB'
        ),
    },
    {
        'panti_username': 'sayap_ibu',
        'title': 'Renovasi Ruang Tidur Telah Selesai',
        'content': (
            'Setelah beberapa bulan proses renovasi, ruang tidur anak-anak kini telah selesai '
            'diperbaiki dan dipercantik. Anak-anak sangat antusias dengan suasana baru yang '
            'lebih nyaman. Cat dinding baru, kasur baru, dan pencahayaan yang lebih baik '
            'membuat ruangan terasa lebih hangat dan homey. Renovasi ini didanai penuh oleh '
            'donasi dari masyarakat sekitar.'
        ),
    },
]

VIDEO_DATA = [
    {
        'panti_username': 'sayap_ibu',
        'title': 'Kegiatan Olahraga Pagi Bersama',
        'description': (
            'Anak-anak panti asuhan melakukan senam dan olahraga pagi bersama untuk menjaga '
            'kesehatan dan semangat. Kegiatan rutin ini dilaksanakan setiap Sabtu pagi.'
        ),
        'video_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    },
    {
        'panti_username': 'al_hidayah',
        'title': 'Pentas Seni Anak Panti 2026',
        'description': (
            'Penampilan seni dari anak-anak berbakat panti asuhan dalam acara tahunan pentas '
            'seni. Berbagai penampilan memukau dari tari tradisional, drama, hingga musikalisasi '
            'puisi ditampilkan oleh anak-anak berbakat.'
        ),
        'video_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    },
    {
        'panti_username': 'kasih_ibu',
        'title': 'Kunjungan Donatur ke Panti',
        'description': (
            'Dokumentasi kunjungan para donatur yang datang langsung untuk berinteraksi dengan '
            'anak-anak. Momen kebersamaan ini selalu menjadi kenangan indah bagi semua pihak.'
        ),
        'video_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    },
]


class Command(BaseCommand):
    help = 'Seed database with sample berita and video content'

    def handle(self, *args, **options):
        self.stdout.write('Seeding content data...')

        # 1. Create panti users + profiles
        panti_map = {}
        for data in PANTI_DATA:
            user, created = User.objects.get_or_create(
                username=data['username'],
                defaults={
                    'email': data['email'],
                    'password': make_password('Panti123!'),
                    'role': 'panti',
                },
            )
            profile, _ = OrphanageProfile.objects.get_or_create(
                user=user,
                defaults={
                    'nama_panti': data['nama_panti'],
                    'alamat_panti': data['alamat_panti'],
                    'nomor_panti': data['nomor_panti'],
                },
            )
            panti_map[data['username']] = (user, profile)
            status = 'created' if created else 'already exists'
            self.stdout.write(f"  Panti '{data['nama_panti']}': {status}")

        # 2. Seed beritas
        berita_count = 0
        for data in BERITA_DATA:
            user, profile = panti_map[data['panti_username']]
            _, created = Berita.objects.get_or_create(
                title=data['title'],
                panti=profile,
                defaults={
                    'content': data['content'],
                    'author': user,
                    'is_published': True,
                },
            )
            if created:
                berita_count += 1

        self.stdout.write(f"  Berita: {berita_count} created")

        # 3. Seed videos
        video_count = 0
        for data in VIDEO_DATA:
            user, profile = panti_map[data['panti_username']]
            _, created = Video.objects.get_or_create(
                title=data['title'],
                panti=profile,
                defaults={
                    'description': data['description'],
                    'video_url': data['video_url'],
                    'author': user,
                    'is_published': True,
                },
            )
            if created:
                video_count += 1

        self.stdout.write(f"  Video: {video_count} created")
        self.stdout.write(self.style.SUCCESS('Done! Seed selesai.'))
